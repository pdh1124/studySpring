package kr.icia.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.icia.domain.BoardAttachVO;
import kr.icia.domain.BoardVO;
import kr.icia.domain.Criteria;
import kr.icia.domain.PageDTO;
import kr.icia.service.BoardService;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

/*
 @Controller : 스프링 컴파일러에 controller 라고 알림
  - 위 어노테이션이 있으면 자동으로 메모리에 등록.
  - 생성, 초기화, 할당을 모두 자동으로 처리
 @RequestMapping : url 요청에 대한 처리를 명시.
  - jsp 게시판에서 @WerbServlet 역할과 비슷
 */

@Log4j
@Controller
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	
	private BoardService service;
	
	/*
	 @GetMapping : 페이지 요청 방식이 get일 경우. = @RequestMapping(value = "/list", method = RequestMethod.GET)
	 @PostMapping : 페이지 요청 방식이 post일 경우.  = @RequestMapping(value = "/list", method = RequestMethod.POST)
	 */
	@GetMapping("/list")
	public void list(Model model, Criteria cri) {
		log.info("list: " + cri);
		model.addAttribute("list", service.getList(cri));
		// 과거 jsp에서는 requset.setAttribute로 ArrayList를 전달했지만
		// , 같은 역할을 model이 대신.
		
		// 컨트롤러 > 서비스 > 매퍼 > mybatis
		int total = service.getTotal(cri);
		log.info("total : " + total);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	//글쓰기 버튼을 누르면, 게시물 입력폼 보이기
	@GetMapping("/register")
	public void register() {	
		//이동할 주소를 리턴하지 않는다면, 요청한 이름으로의 jsp 파일을 찾음.
	}
	
	
	//글쓰기
	// jsp 대비로 if~else 분기 처리가 필요 없음
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		//@Controller 어노테이션이 붙고,
		//컴포넌트 스캔에 패키지가 지정되어 있다면,
		//매개변수 인자들은 스프링이 자동으로 생성 할당 함
		log.info("register : " + board);
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		//리다이렉트 시키면서 1회용 값을 전달.
		//Flash가 1회용이라는 뜻
		
		//첨부파일이 있다면 log로 찍어보기
//		if (board.getAttachList() != null) { //첨부파일이 있다면,
//			board.getAttachList().forEach(attach -> log.info(attach));
//			//첨부파일의 각 요소를 로그로 출력.
//		}
		
		return "redirect:/board/list";
	}
	
	//읽기
	//제목 링크를 클릭하여 글 상세보기 - get방식
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") Long bno, Model model, @ModelAttribute("cri") Criteria cri) {
		// @RequestParam : 요청 전달값으로 글번호 이용.
		log.info("/get");
		model.addAttribute("board", service.get(bno));
		//jsp에서 request.setAttribute 하던 것과 비슷.
		//전달값으로 명시만 하면 스프링이 자동 처리
		//사용하는 부분만 추가 구현
		
		//model.addAttribute("cri", cri) : @ModelAttribute("cri")를 생략하고 사용해도 됨
		//@ModelAttribute("cri") Criteria cri : cri로 초기화한 값을 get.jsp에 cri라는 이름으로 전달.
	}
	
	//수정
	//post 요청으로 /modify 가 온다면, 아래 메소드 수행.
	@PostMapping("/modify")
	public String modify(BoardVO board, RedirectAttributes rttr, Criteria cri) {
		
		log.info("modify : " + board);
		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		//수정이 성공하면 success 메세지가 포함되어 이동
		//실패해도 메세지 빼고 이동
		
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		//addFlashAttribute : 1회성, url 표시창에 전달되지 않음.
		//addAttribute : 지속, url 표시됨
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list";
	}
	
	
	//삭제
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr, @ModelAttribute("cri") Criteria cri) {
		
		log.info("remove..." + bno);
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno)) {
			deleteFiles(attachList); //서버디스크의 파일 정보 삭제
			rttr.addFlashAttribute("result", "success");
		}
		
//		rttr.addAttribute("pageNum", cri.getPageNum());
//		rttr.addAttribute("amount", cri.getAmount());
		//addFlashAttribute : 1회성, url 표시창에 전달되지 않음.
		//addAttribute : 지속, url 표시됨
//		rttr.addAttribute("type", cri.getType());
//		rttr.addAttribute("keyword", cri.getKeyword());
		
		//return "redirect:/board/list";
		return "redirect:/board/list" + cri.getListLink();
		//pageNum,amount,type,keyword를 getListLink에 한번에 전달
	}
	
	
	//게시물번호를 이용해서 첨부파일의 목록을 가져와서 리스트 타입으로 만들어서 ResponseEntity로 만들어서 전달
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
		log.info("getAttachList: " + bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	//첨부파일을 각각 찾아서 하나씩 삭제하는 메소드
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if (attachList == null || attachList.size() == 0) {
			return; //리스트가 없거나 첨부파일이 없다면 끝내라,
		}
		
		log.info("delete attach file......");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("c:\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());
				Files.deleteIfExists(file);
			} catch (Exception e) {
				e.printStackTrace();
			}
		});
	}
}
