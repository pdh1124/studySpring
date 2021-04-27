package kr.icia.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.icia.domain.Criteria;
import kr.icia.domain.ReplyPageDTO;
import kr.icia.domain.ReplyVO;
import kr.icia.mapper.BoardMapper;
import kr.icia.mapper.ReplyMapper;
import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;


@Log4j // lombok 로그 사용
@Service //이 클래스가 서비스 계층을 맡는다고 알림.
@AllArgsConstructor //모든 매개변수에 대한 생성자 생성.(생성자 여러개 아님)
public class ReplyServiceImp implements ReplyService {
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	// 매퍼를 조작할 수 있도록 멤버 변수를 생성하고,
	// 객체를 자동 초기화 하고 있음
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;
	// 게시물 테이블과 댓글 테이블은 동시에 동작하거나 취소 되어야함
	// @Transactional 이용. 2개의 쿼리문을 동시에 움직이게 할 때 사용
	
	@Transactional
	@Override
	public int register(ReplyVO vo) {
		log.info("register......"+vo);
		boardMapper.updateReplyCnt(vo.getBno(), 1);
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(Long rno) {
		log.info("get......"+rno);
		return mapper.read(rno);
	}
	
	@Transactional
	@Override
	public int remove(Long rno) {
		log.info("remove......"+rno);
		ReplyVO vo =mapper.read(rno);
		boardMapper.updateReplyCnt(vo.getBno(), -1);
		return mapper.delete(rno);
	}

	@Override
	public int modify(ReplyVO reply) {
		log.info("modify......"+reply);
		return mapper.update(reply);
	}

	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		log.info("get Reply list......"+bno);
		return mapper.getListWithPaging(cri, bno);
	}

	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		return new ReplyPageDTO(mapper.getCountByBno(bno),mapper.getListWithPaging(cri, bno));
		//각각의 매퍼를 이용하여 댓글의 갯수와 댓글의 목록 추출.
	}

}
