package kr.icia.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.icia.domain.BoardVO;
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
	public void list(Model model) {
		log.info("list");
		model.addAttribute("list", service.getList());
		// 과거 jsp에서는 requset.setAttribute로 ArrayList를 전달했지만
		// , 같은 역할을 model이 대신.
		
		// 컨트롤러 > 서비스 > 매퍼 > mybatis
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
		
		return "redirect:/board/list";
	}
	
	//읽기
	//제목 링크를 클릭하여 글 상세보기 - get방식
	@GetMapping("/get")
	public void get(@RequestParam("bno") Long bno, Model model) {
		// @RequestParam : 요청 전달값으로 글번호 이용.
		log.info("/get");
		model.addAttribute("board", service.get(bno));
		//jsp에서 request.setAttribute 하던 것과 비슷.
		//전달값으로 명시만 하면 스프링이 자동 처리
		//사용하는 부분만 추가 구현
	}
	
	//수정
	//post 요청으로 /modify 가 온다면, 아래 메소드 수행.
	@PostMapping("/modify")
	public String modify(BoardVO board, RedirectAttributes rttr) {
		
		log.info("modify : " + board);
		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		//수정이 성공하면 success 메세지가 포함되어 이동
		//실패해도 메세지 빼고 이동
		
		return "redirect:/board/list";
	}
	
	
	//삭제
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr) {
		
		log.info("remove..." + bno);
		if(service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
		}
		return "redirect:/board/list";
	}
}
