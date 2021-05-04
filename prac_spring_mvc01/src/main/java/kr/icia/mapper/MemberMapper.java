package kr.icia.mapper;

import kr.icia.domain.MemberVO;

public interface MemberMapper {
	public MemberVO read(String userid);
	//사용자가 아이디를 입력하면, 그에 해당하는 계정 정보를 디비에서 추출.
}
