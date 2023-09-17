# 태그미: Tag Me

<p align="center">
  <br>
  
  ![태그미1](https://github.com/Team-SmallCloud/smallCloud-iOS/assets/67594952/5c2ca025-ef62-4c47-aa84-736ce915d463)
  
  <br>
</p>


## 프로젝트 소개 👩‍🏫

<p align="justify">
<b>태그미</b>는 유기동물 문제를 소프트웨어로 풀어낼 방법을 고민하며 나온 프로젝트입니다. <br>
  앱에서 보소호의 동물을 확인하고 유기동물을 발견하면 NFC로 동물등록 여부를 판단합니다.
</p>

<br>

<br>

## 스택 🔨

### 기술 스택
- 프로젝트 구조: MVC
- 인터페이스: Storyboard
- 패키지 관리: SPM
- 외부 라이브러리: Lottie, Alamofire, SwiftyJSON
- URLSession
- NSCache
- Core Data
- Core NFC

### 개발 환경
- OS: macOS Monterey(12.X)
- IDE: Xcode13.2.1
- 디자인: Figma

<br>

## 앱 구성

### 첫화면
앱을 처음 진입했을 때 나타나는 화면입니다.<br>
로그인, 회원가입이 가능하며 회원정보는 Core Data를 활용해 로컬저장소에 저장됩니다<br>
Lottie 라이브러리를 활용해 애니메이션을 적용했습니다.<br>
| 첫화면 | 회원가입-회원등록 | 회원가입-동물등록 | 화면전환 |
| :------: | :------: | :------: | :-----: |
| ![image](https://github.com/Team-SmallCloud/smallCloud-iOS/assets/67594952/deb01819-cf3f-43c4-b684-4dd548112141) | ![image](https://github.com/Team-SmallCloud/smallCloud-iOS/assets/67594952/1a388575-ae1a-49ad-aba9-76c781d9fc6c) | ![image](https://github.com/Team-SmallCloud/smallCloud-iOS/assets/67594952/2320d8a3-9227-4bab-9d6a-cf345240bfd4) | ![image (2)](https://github.com/Team-SmallCloud/smallCloud-iOS/assets/67594952/28591456-7d3b-400d-ba28-71e6e712141d) |

<br>

### 게시판
보호소에서 임시 보호중인 동물을 확인할 수 있습니다.<br>
농림축산식품부의 유기동물 정보 조회 서비스 Open API를 활용했습니다.<br>
| 게시판 | 상세보기 |
| :------: | :------: | 
|![image](https://github.com/Team-SmallCloud/smallCloud-iOS/assets/67594952/eb8a60f2-97ff-4e31-8f57-b3c0cdc786a8) | ![image (4)](https://github.com/Team-SmallCloud/smallCloud-iOS/assets/67594952/3db3f6c3-25ec-40a2-8e60-4c726ae27504) |

<br>

### NFC태그
유기동물을 발견했을 때 NFC로 동물등록 여부를 확인할 수 있습니다.<br>
| 기본화면 | NFC스캔 활성화 |
| :------: | :------: | 
| ![image](https://github.com/Team-SmallCloud/smallCloud-iOS/assets/67594952/11cc520f-a86e-450f-8923-d8a351bccc22) | ![image (5)](https://github.com/Team-SmallCloud/smallCloud-iOS/assets/67594952/c325c783-7c2e-4fc0-9896-a9e970c0b9db) |

<br>

### 주변 동물병원 찾기
도움을 받을 수 있는 동물병원을 지도에 표시합니다.<br>
Kakao Map Open API를 활용했습니다.<br>
| 지도 |
| :------: | 
| ![image](https://github.com/Team-SmallCloud/smallCloud-iOS/assets/67594952/56e59ba2-2670-4ec5-905c-8f2205753479) |

<br>
<br>
