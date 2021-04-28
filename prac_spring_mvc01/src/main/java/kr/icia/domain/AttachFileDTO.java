package kr.icia.domain;

import lombok.Data;

@Data
public class AttachFileDTO {
	private String fileName;
	private String uploadPath;
	private String uuid; //universally unique identifier, UUID, 범용 고유 식별자(예를 들어 주민번호).
	private boolean image;
}
