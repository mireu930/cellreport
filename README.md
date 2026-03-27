# cellreport
cellreport는 셀(소모임/교회 셀) 활동을 기록하고 관리하기 위한 모바일 셀보고서 앱입니다.  
공지 확인, 출석/보고 관련 정보 관리, 설정 기능 등을 제공하여 셀 운영을 더 쉽고 체계적으로 돕습니다.
## 주요 기능
- 공지사항 조회
- 셀보고서 관련 정보 확인 및 관리
- 앱 설정 관리
## 기술 스택
- Flutter
- go_router
- provider
- flutter_dotenv
- supabase_flutter
## 주요 디렉토리 설명
- `lib/clients`: 외부 서비스(API, SDK) 통신 클라이언트
- `lib/models`: 앱 데이터 구조(모델/엔티티)
- `lib/screens`: 화면 단위 UI
- `lib/services`: 비즈니스 로직
- `lib/states`: 상태 관리 로직
- `lib/theme`: 테마/디자인 시스템
- `lib/utils`: 공통 유틸 함수
- `lib/widgets`: 재사용 위젯