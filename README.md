# Spring MVC 패턴 게시판

## 개발일정
2021.04.08 ~ 2021.05.07

## 사용기술
Language : Java, JSP, HTML, CSS, JavaScript
Framework : Spring, Mybatis, JQuery, Bootstrap
DB : ORACLE
Server : Tomcat v9.0
Design Pattern : MVC (Model - View – Controller)
암호화 : Spring-Security


## 사전작업 :
1. spring에 대한 이해와 기능을 구현을 위해 게시판 형태로 작업
2. 데이터베이스를 정의하고 설계 및 구현
3. 프로젝트 시작하기 전 디자인 확인 및 bootstrap연동
4. 게시판을 작동하기 위한 기능들 수집

### 게시물 작성(등록) :
- oracle DB에 게시물을 담을 테이블을 생성함.
- 등록 페이지를 생성해 게시글을 작성하고 글 제목과 작성자, 글내용을 입력해 데이터 베이스에 담아 저장을 하는 것을 구현함.
- 글 작성시 글 번호를 시퀀스로 차례대로 받고 제목과 작성자, 내용을 입력 받음.
- 
![image](https://user-images.githubusercontent.com/75818141/128600930-b9713cc5-c6be-48ca-8f11-3271976b104a.png)
![image](https://user-images.githubusercontent.com/75818141/128600951-0994e50a-8c00-48b2-856f-07a2a9e54054.png)


### 게시물 리스트 구현 :
- 리스트 페이지를 생성함.
- 등록한 게시물들을 한번에 볼수 있도록 각각 리스트를 c:forEach 문을 이용하여 하나하나 꾸려줌.
- 각각의 제목을 클릭하면 상세 내용을 볼 수 있도록 링크 시킴.
- 
![image](https://user-images.githubusercontent.com/75818141/128600996-fd1428e4-4c07-401c-b531-8b317158a6a5.png)


### 게시물 읽기(상세페이지) : 
- 상세페이지를 생성한다.
- 작성한 글을 볼 수 있도록 글 번호, 작성자, 내용을 데이터 베이스에서 꺼내서 각각 볼 수 있도록 value값으로 꾸려줌.
- 
![image](https://user-images.githubusercontent.com/75818141/128601001-7454eb79-0b98-424c-9297-c6ae4f0296e7.png)


### 게시물 수정 : 
- 게시물 등록 페이지와 비슷한 틀에 input박스안에 입력된 게시물의 내용을 미리 담아두고 수정 할 수 있도록 만듦.
- update문을 사용하여 게시물 작성한 게시물의 제목 및 작성자, 글 내용을 직접 불러와 수정 할 수 있도록 사용.
- 등록 페이지를 가져와 데이터 베이스에 있는 내용을 넣은 뒤 각각 수정 하도록 함.
- 
![image](https://user-images.githubusercontent.com/75818141/128601020-9b9fe498-3f1b-41e2-b38d-a1922664d862.png)
![image](https://user-images.githubusercontent.com/75818141/128601031-442d13a0-2798-46e1-862b-970c74c92b3b.png)


### 게시물 삭제 :
- 수정 페이지에 삭제 버튼을 만들어 input박스에 글번호를 가져오도록 하고 삭제 버튼을 만듦.
- 게시물 번호를 가져와 데이터베이스에서 해당 내용을 담긴 내용을 삭제한다.
- 
![image](https://user-images.githubusercontent.com/75818141/128601043-ecc89eb5-87b8-406d-b0b0-aee7f2b76fb6.png)


### 게시물 첨부파일 등록 :
- oracle DB에 게시물을 담을 테이블을 테이블을 생성함.
- 게시물 테이블에 있는 글 번호와 외래키를 지정해 연동을 한다.
- 게시물 이름과 경로 고유아이디를 담을 수 있도록 설정한다.
- 고유아이디는 랜덤인 숫자로 만들고 아이디뒷에 붙여서 같은 이름의 파일을 넣어도 중복 되지 않도록 설정.
- 파일 경로를 년도/월/일로 나누어 정렬하여 저장할 수 있도록 만듦.
-  ajax처리로 첨부파일을 등록할때 바로 비동기 처리로 바로 올라 올 수 있도록함.
- 하나등록할때 여러개의 첨부파일을 등록 할 수 있도록 한다.
- 
![image](https://user-images.githubusercontent.com/75818141/128601061-85589226-5643-476b-a747-385134e610a4.png)


### 게시물 첨부파일 삭제 :
- 등록페이지나 수정페이지에서 첨부파일이 올라와있을때 [x]버튼을 클릭하면 올라간 첨부파일이 ajax로 바로 삭제 될 수있도록 비동기 처리를 함
- 데이터 베이스에 올라온 첨부파일도 같이 삭제 됨.
- 게시물 삭제시 게시물에 등록되어있던 첨부파일도 다 같이 삭제됨.
- 
![image](https://user-images.githubusercontent.com/75818141/128601081-5dad235a-2f53-4f1e-8e75-8bf0b384f9aa.png)


### 댓글 작성 :
- oracle DB에 댓글을 담을 테이블을 테이블을 생성한 후 게시물 번호를 외래키로 지정해 연동한다.
- 게시물에 댓글을 작성할 수 있는 폼을 만든다.
- 댓글을 작성할 때 작성자와 댓글 내용을 적을 input을 만든다.
- 한 게시물에 여러개의 댓글을 달 수 있도록 구현.
- 
![image](https://user-images.githubusercontent.com/75818141/128601104-8391d459-a053-4386-925a-f922214736b7.png)
![image](https://user-images.githubusercontent.com/75818141/128601109-2c3cd74b-5558-4e7f-ae44-c9ff9fbd408d.png)


### 댓글 목록 : 
- ajax처리로 등록할때 바로 보일 수 있도록 만든다.
- 여러개의 리스트를 글 읽기 페이지에 리스트를 꾸린다.
- 게시물 리스트에 글마다 제목 옆에 몇개의 댓글이 달린지 표시한다.
- 
![image](https://user-images.githubusercontent.com/75818141/128601136-7b4a3556-a031-4bc5-b354-207efd0b6784.png)



### 댓글 수정 :
- 댓글 입력한 곳에 수정 버튼을 누르면 수정이 가능하도록 구현.
- update로 데이터베이스에 입력된 댓글을 수정할 수 있도록 구현.
- 
![image](https://user-images.githubusercontent.com/75818141/128601148-7e6a4a44-7e33-4d65-9a90-09cd54de4d39.png)
![image](https://user-images.githubusercontent.com/75818141/128601160-927b6599-dfce-445a-bd94-684599b096dc.png)


### 댓글 삭제 :
-입력한 댓글의 번호를 받아 삭제 가능하도록 처리.

![image](https://user-images.githubusercontent.com/75818141/128601167-9d2c063f-7e00-4e69-99c1-30ed30c4c969.png)


### 회원 관리 :
- 로그인으로 기능을 구현하고 security로 보안관리를 한다. 
- 로그인 한 계정만 글 작성 및 수정 삭제를 가능 하도록 수정 및 구현.
- 로그인 한 계정만 댓글 작성 및 댓글수정 삭제를 가능 하도록 구현.
- 
![image](https://user-images.githubusercontent.com/75818141/128601177-f76337e0-6511-4a19-af81-3046c4b895f0.png)
![image](https://user-images.githubusercontent.com/75818141/128601190-c662e005-f14f-4f85-89f3-64537514d244.png)


