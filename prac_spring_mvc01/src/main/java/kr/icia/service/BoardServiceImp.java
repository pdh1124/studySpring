package kr.icia.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.icia.domain.BoardAttachVO;
import kr.icia.domain.BoardVO;
import kr.icia.domain.Criteria;
import kr.icia.mapper.BoardAttachMapper;
import kr.icia.mapper.BoardMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j // lombok 로그 사용
@Service //이 클래스가 서비스 계층을 맡는다고 알림.
//@AllArgsConstructor //모든 매개변수에 대한 생성자 생성.(생성자 여러개 아님)
public class BoardServiceImp implements BoardService {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	@Transactional
	@Override
	public void register(BoardVO board) { //글쓰기에 대한 처리
		log.info("register......" + board); //안내 메세지
		mapper.insertSelectKey(board); //동작
		// mapper는 인터페이스 객체를 생성하고.
		// mapper를 통해서 메소드를 호출
		// 호출을 하면 매핑되어 있는 쿼리문이 동작.
		
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {
			//첨부파일이 없다면, 
			return; //끝낸다.
		}
		
		//첨부파일이 있다면
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno()); //게시물의 번호를 할당해 주고
			attachMapper.insert(attach); //attach에 정보를 db에 전달해준다.
		});
	}

	@Override
	public BoardVO get(Long bno) { //게시물 하나 읽기
		log.info("get......" + bno); 
		return mapper.read(bno); 
	}

	@Override
	public boolean modify(BoardVO board) { //수정할 정보 전달
		log.info("modify......" + board);
		return mapper.update(board) == 1; //update가 1이 리턴되고 같다면 true, 아니면 false
	}

	@Override
	public boolean remove(Long bno) {
		log.info("remove......"+bno);
		return (mapper.delete(bno)) == 1; ////delete가 1이 리턴되고 같다면 true, 아니면 false
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("getList......");
		//return mapper.getList(); //List<BoardVO>로 받아서 List 처리
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {	
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get Attach list by bno: " + bno);
		return attachMapper.findByBno(bno);
		// 게시물 번호를 전달하고,
		// 게시물 번호와 일치하는 첨부파일을 모두 리턴.
	}

}
