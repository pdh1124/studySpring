package kr.icia.domain;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

public class CustomUser extends User {
	//사용자 정보와 권한을 등록하고, 
	//로그인을 하면 관련 정보는 세션에 저장.
	//페이지 이동시 로그인 여부 판별
	//User 클래스는 사용자 정보를 가지고 있고 
	//spring의 시큐리티 세션에서 사용하기 편하도록 구성되어 있음
	//(만약, User 클래스를 사용하지 않는 다면, jsp게시판에서 세션의 사용처럼 일일이 지정해줘야함.)
	//User 클래스를 사용하므로해서, 초기 설정은 복잡하지만, 이후 자동처리로 편리함

	private static final long serialVersionUID = 1L; //직렬화 (형식을 맞춰준 것 뿐)
	private MemberVO member; //디비에서 추출한 회원정보 초기화.
	
	public CustomUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
		// 상속을 받으면서 의무적으로 구현한 생성자.
		// <? extend 클래스명> : 제너릭 타입의 상위 제한.
		// <? super 클래스명> : 제너릭 타입의 하위 제한.
		// <?> : 제너릭 타입 제한 없음
		// http://blog.naver.com/qkrghdud0/220697126377
	}
	
	public CustomUser(MemberVO vo) {
		super(vo.getUserid(), vo.getUserpw(), vo.getAuthList().stream()
				.map(auth -> new SimpleGrantedAuthority(auth.getAuth())).collect(Collectors.toList())); 
		this.member = vo;
		//사용자 아이디, 패스워드, 권한 목록으로 초기화.
	}
	
	//사용자가 로그인 창에서 아이디와 패스워드를 입력하면,
	//해당 아이디를 가지고 일치하는 회원정보를 찾기.(서비스 처리)
	
}
