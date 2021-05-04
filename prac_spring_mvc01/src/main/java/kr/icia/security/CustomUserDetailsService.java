package kr.icia.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import kr.icia.domain.CustomUser;
import kr.icia.domain.MemberVO;
import kr.icia.mapper.MemberMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService {
	@Setter(onMethod_ = { @Autowired })
	private MemberMapper memberMapper;
	//쿼리 조작을 위한 멤퍼 인터페이스 초기화
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		log.warn("load user by userName : " + username);
		MemberVO vo = memberMapper.read(username);
		//전달된 id로 사용자 정보를 검색.
		
		return vo == null ? null : new CustomUser(vo);
		// 검색되지 않으면 null, 검색되면 해당 정보를 리턴.
	}

}
