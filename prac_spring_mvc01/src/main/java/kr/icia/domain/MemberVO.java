package kr.icia.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class MemberVO {
	private String userid;
	private String userpw;
	private String userName;
	private boolean enabled; //계정 정지 유무
	
	private Date regDate;
	private Date updateDate;
	private List<AuthVO> authList;
	//하나의 아이디는 여러개의 권한 소유 가능.
}
