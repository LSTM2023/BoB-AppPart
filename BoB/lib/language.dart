import 'package:get/get.dart';

class Languages extends Translations{
  @override
  Map<String, Map<String, String>> get keys =>{
    'ko_KR':{
      'main_1' : '홈',
      'main_3' : '일기',
      'main_4' : '마이페이지',
      'appbar_login' : '이메일 로그인',
      'appbar_findLogInfo' : '로그인 정보 찾기',
      'appbar_main2' : '홈캠',
      'babyName' : '아기 이름',
      'Init_loginBtn' : '이메일로 로그인',
      'Init_signUpBtn' : '회원가입',
      'Init_Inquiry' : '로그인 문의',
      'login_id' : '아이디',
      'login_pass' : '비밀번호',
      'login_btn' : '로그인',
      'login_nickname' : '닉네임',
      'login_phone' : '휴대폰 번호',
      'login_modified' : '수정 완료',
      'login_findID' : '아이디 찾기',
      'login_findPass' : '비밀번호 찾기',
      'login_successLoginTitle' : '로그인 성공',
      'login_failLoginTitle' : '로그인 실패',
      'login_successLoginContent' : '환영합니다',
      'login_failLoginContent' : '등록된 사용자가 아닙니다',
      'main4_manageBaby' : '아이 관리',
      'main4_addBaby' : '아이 추가',
      'main4_modifyBaby' : '아이 수정',
      'main4_babyAddModify' : '아이 추가/수정',
      'main4_InviteBabysitter' : '추가 양육자 초대',
      'main4_switch_Alarm' : '알림 ON / OFF',
      'main4_logout' : '로그아웃',
      'main4_modifyUserInfo' : '회원정보 수정',
      'main4_changeLanguage' : '언어모드 변경',
      'main4_withdrawal' : '서비스 탈퇴',
      'main2_accessWeek' : '접근 가능 요일',
      'main2_accessTime' : '접근 가능 시간',
      'main2_notAccessTitle' : '현재 홈캠에 접근할 수 없습니다.',
      'main4_profileName' : ' 님',
      'main4_profileGreeting' : '좋은 아침 입니다!',
      'main4_profileMyBaby' : '나의 아기',
      'main4_profileAwaitingBaby' : '초대 수락 대기중',
      'withdraw_title' : '회원 탈퇴 안내',
      'withdraw_content' : '지금까지 BoB 서비스를 이용해주셔서 감사합니다.\n회원을 탈퇴하면 BoB 서비스 내 나의 계정 정보 및 근무기록 내역이 삭제되고 복구 할 수 없습니다.',
      'withdraw_checkPhrase' : '위 내용을 숙지하였으며, 동의합니다.',
      'withdraw_btn' : '탈퇴하기',
      'cancle' : '취소',
      'withdraw_finalchekContent' : '탈퇴 시 본인 계정의 모든 기록이 삭제됩니다.\n 탈퇴하시겠습니까?',
      'main4_changeLM' : '언어 모드 변경',
      'accept' : '수락',
      'confirm' : '확인',
      'invitation_Err' : '초대 불가',
      'invitation_ErrC' : '아이를 먼저 등록해 주세요',
      'invitation_invTitle' : '초대 하기',
      'invitation_accept' : '초대 수락',
      'invitation_acceptC' : '초대를 수락하시겠습니까?',
      'invitation_notList' : '미수락 초대',
      'invitation_invContent' : '공유 코드를 발급해 주세요',
      'invitation2_id' : '초대할 ID',
      'invitation2_idDeco' : '아이디를 입력해 주세요',
      'invitation2_accY' : '접근 요일 선택',
      'invitation2_accT' : '접근 시간 설정',
      'selectBaby' : '아기 선택',
      'relation' : '관계',
      'relation0' : '부모',
      'relation1' : '가족',
      'relation2' : '베이비시터',
      'registration' : '등 록',
      'invitation2_setT' : '시간 선택',
      'week0' : '월',
      'week1' : '화',
      'week2' : '수',
      'week3' : '목',
      'week4' : '금',
      'week5' : '토',
      'week6' : '일',
      'birth' : '생일',
      'babyNullErr' : '최소 한명의 아기는 등록되어 있어야 합니다!',
      'babyNameHint' : '아기의 이름 또는 별명을 입력해 주세요',
      'genderF' : '여아',
      'genderM' : '남아',
      'gender' : '성별',
      'modify' : '수정',
      'delete' : '삭제',
      'babyList' : '아기 리스트',
      'babyListC' : '클릭하면 해당 아기를 관리할 수 있습니다.',
      'modi_BabyErr' : '부모 관계인 아기만 수정 가능합니다',
      'life_record' : '생활 기록',
      'grow_record' : '성장 기록',
      'height, weight' : '키, 몸무게',
      'Infant 0~72 months height percentile' : '유아 0~72개월 신장 백분위 수',
      'Infant 0~72 months weight percentile' : '유아 0~72개월 몸무게 백분위 수',
      'male' : '남아 ---',
      'female' : '여아 ---',
      'vaccination' : '예방 접종',
      'next_vaccination' : '다음 예방 접종',
      '0~6_months' : '0~6개월',
      '12~35_months' : '12~35개월',
      'ages_4-12' : '만 4~12세',
      'Vaccination_date' : '접종일 \: ',
      'Recommended_vaccination' : '접종 권장일 \: ',
      'Recommend_date' : '권장시기 \: ',
      'Vaccinated' : '접종',
      'Unvaccinated' : '미접종',
      'medical_checkup' : '건강 검진',
      'next_medical_checkup' : '다음 건강 검진',
      'timer_explanation' : '버튼을 길게 누르면 타이머가 작동합니다.',
      'life0' : '모유',
      'life1' : '젖병',
      'life2' : '이유식',
      'life3' : '기저귀',
      'life4' : '수면',
      'put_image' : '사진 첨부',
      'change_image' : '사진 바꾸기',
      'uploaded' : '업로드 되었습니다.',
      'upload' : '업로드',
      'modified' : '수정되었습니다',
      'q_delete' : '삭제하시겠습니까?',
      'enter_title' : '제목을 입력하세요.',
      'title' : '제목',
      'enter_content' : '내용을 입력하세요.',
      'content' : '내용',
      'cancel' : '취소',
      'New' : '추가',
      'total' : '전체',
      'finish' : '완료',
      'year' : '년',
      'month' : '월',
      'day' : '일',
      'day_birth' : '일생',
      'once_delete' : '한 번 삭제한 내용은 복구가 불가능합니다.\n 정말로 삭제하시겠습니까?',
      'not_deleted' : '삭제하지 못했습니다.',
      'homecam' : '홈캠',
      'temp' : '온도',
      'humid' : '습도',
      'new_update' : '갱신',
      'height' : '키',
      'weight' : '몸무게',
      'life3_0' : '대변',
      'life3_1' : '소변',
      'memo' : '메모',
      'enter_food' : '이유식 시간을 입력하세요',
      'babyfood_time' : '이유식 시간 \:',
      'amount_food' : '이유식 양(ml)',
      'register_record' : '등 록',
      'enter_sleep' : '수면 시간을 입력하세요',
      'sleeping_time' : '수면 시간 \:',
      'enter_hweight' : '키, 몸무게 입력',
      'select_height' : '스크롤하여 키를 선택해 주세요',
      'select_weight' : '스크롤하여 몸무게를 선택해 주세요',
      'select_date' : '측정 날짜를 선택해주세요',
      'type_feed' : '수유 타입',
      'powdered_milk' : '분유',
      'enter_feed' : '수유 시간을 입력하세요.',
      'amount_feed' : '수유량(ml)',
      'feeding' : '수유',
      'feeding_time' : '수유 시간 \:',
      'dir_feed' : '수유 방향',
      'left' : '왼쪽',
      'right' : '오른쪽',
      'Defecation' : '배소변',
      'enter_def' : '배변 시간을 입력하세요',
      'graph_growth' : '성장 통계',
      'first_growth_record' : '먼저 키와 몸무게를 입력하세요',
      '\'s growth record' : '의 성장 기록',
      '\'s weight record' : '의 몸무게 기록',
      'standard_growth' : '표준 성장',
      'check_diagram' : '도표 확인',
      'vaccine_age' : '만 12세까지 접종',
      'temperature_vac' : '기준 : 질병관리청 표준 예방접종 일정표',
      'invitation' : '초대',
      'select_id_invi' : '초대할 ID를 검색해주세요',
      'select_baby_invi' : '아기를 선택해주세요',
      'keep_id' : '아이디 형식을 지켜주세요',
      'not_exist_ids' : '존재하지 않는 아이디입니다',
      'find_exist' : '아이디를 찾았습니다',
      'license' : '오픈소스 고지',
      'warning' : '주의',
      'warning_form' : '입력 양식을 지켜주세요.',
      'search_completed': '검색 완료',
      'invitation_complete' : '초대 완료하였습니다.',
      'medical_done' : '검진 완료일',
      'medical_period' : '검진기간',
      'finish_previous_check' : '이전 검진을 먼저 완료해주세요',
      'checkup' : '검진',
      'noncheckup' : '미검진',
      'check_period' : '검진시기',
      'check_recommend' : '권장기간',
      'checkup_done' : '건강검진 완료',
      'checkup_finish' : '검진을 완료하였습니다',

      'id_input_hint' : '이메일을 입력해주세요',
      'pw_input_hint' : '비밀번호는 8~16자를 입력해주세요.',
      'pwCheck_input_hint' : '비밀번호 재입력.',
      'name_input_hint' : '닉네임을 입력해주세요.',
      'phone_input_hint' : '휴대폰 번호를 입력해주세요.',
      'qaType_input_hint' : '설정한 질문 유형을 선택해주세요.',
      'qaAnswer_input_hint' : '답변을 입력해주세요.',
      'babyName_input_hint' : '아기의 이름 또는 별명을 입력해주세요.',
      'babyBirth_input_hint' : '아기의 생일을 입력해 주세요.',
      'grow_input_warn' : '먼저 키, 몸무게를 입력해 주세요',
      'qa_val0' : '다른 이메일 주소는?',
      'qa_val1' : '나의 보물 1호는?',
      'qa_val2' : '나의 출신 초등학교는?',
      'qa_val3' : '나의 이상형은?',
      'qa_val4' : '어머니 성함은?',
      'qa_val5' : '아버지 성함은?',
      'life0_ing' : '모유 수유중..',
      'life1_ing' : '젖병 수유중..',
      'life2_ing' : '이유식 먹는중..',
      'life4_ing' : '수면중..',
      'pharse_medicalCheck1' : '생후 71개월전까지 검진',
      'pharse_medicalCheck2' : '기준 : 국민건강보험 영유아건강검진',
      'change_pw' : '비밀번호 변경하기',
      'fail_modify' : '수정에 실패하였습니다',
      'vaild_time_range' : '올바른 시간 범위가 아닙니다.',
      'vaild_week' : '올바른 접근 요일이 아닙니다.',
      'vaild_select_baby' : '초대할 아기와 관계를 선택해주세요.',

    },
    'en_US':{
      'total' : 'total',
      'finish' : 'finish',
      'appbar_login' : 'Email Login',
      'appbar_findLogInfo' : 'Find login information',
      'appbar_main2' : 'Home cam',
      'babyName' : 'baby name',
      'Init_loginBtn' : 'Sign In by email',
      'Init_signUpBtn' : 'Sign Up',
      'Init_Inquiry' : 'Login inquiry',
      'login_id' : 'ID',
      'login_pass' : 'Password',
      'login_nickname' : 'NickName',
      'login_phone' : 'phone number',
      'login_btn' : 'Login',
      'login_modified' : 'Modified',
      'login_findID' : 'find ID',
      'login_findPass' : 'find Password',
      'login_successLoginTitle' : 'Login Success',
      'login_failLoginTitle' : 'Login Fail',
      'login_successLoginContent' : 'Welcome aboard',
      'login_failLoginContent' : 'Not a registered user',
      'main4_manageBaby' : 'Manage Baby',
      'main4_addBaby' : 'Add Baby',
      'main4_modifyBaby' : 'Modify Baby',
      'main4_babyAddModify':'Baby Add/Modify',
      'main4_InviteBabysitter' : 'Invite foster/Babysitter',
      'main4_switch_Alarm' : 'Alarm ON / OFF',
      'main4_logout' : 'logout',
      'main4_modifyUserInfo' : 'modify user information',
      'main4_changeLanguage' : 'language mode',
      'main4_withdrawal' : 'service withdrawal',
      'main2_accessWeek' : 'accessible week',
      'main2_accessTime' : 'accessible time',
      'main2_notAccessTitle' : 'You don\'t have access to home cam right now',
      'main4_profileName' : '',
      'main4_profileGreeting' : 'Good Morning!',
      'main4_profileMyBaby' : 'My Baby',
      'main4_profileAwaitingBaby' : 'Waiting invitation',
      'withdraw_title' : 'Notice of withdrawal from membership',
      'withdraw_content' : 'Thank you for using the BoB service until now.\nIf you leave the membership, your account information and work history in the BoB service will be deleted and cannot be recovered.',
      'withdraw_checkPhrase' : 'I understand and agree',
      'withdraw_btn' : 'To withdraw',
      'cancle' : 'Cancle',
      'withdraw_finalchekContent' : 'When you leave, all records in your account will be deleted.\n Would you like to leave?',
      'main4_changeLM' : 'Change language mode',
      'accept' : 'accept',
      'confirm' : 'confirm',
      'invitation_Err' : 'Not Invited',
      'invitation_ErrC' : 'Please register the child first',
      'invitation_invTitle' : 'Inviting',
      'invitation_accept' : 'Accept Invitation',
      'invitation_acceptC' : 'Do you want to accept the invitation?',
      'invitation_notList' : 'missed invitations',
      'invitation_invContent' : 'Please issue a shared code',
      'invitation2_id' : 'ID to invite',
      'invitation2_idDeco' : 'Please enter your ID',
      'invitation2_accY' : 'Set the day of the week to approach',
      'invitation2_accT' : 'Set access time',
      'selectBaby' : 'select a baby',
      'relation' : 'relation',
      'relation0' : 'parents',
      'relation1' : 'family',
      'relation2' : 'babysitter',
      'registration' : 'Registration',
      'invitation2_setT' : 'Select Time',
      'week0' : 'Mon',
      'week1' : 'Tue',
      'week2' : 'Wed',
      'week3' : 'Thu',
      'week4' : 'Fri',
      'week5' : 'Sat',
      'week6' : 'Sun',
      'birth' : 'birth',
      'babyNullErr' : 'At least one baby must be registered!',
      'babyNameHint' : 'put your baby\'s name or nickname',
      'genderF' : 'girl',
      'genderM' : 'boy',
      'gender' : 'Gender',
      'modify' : 'modify',
      'delete' : 'delete',
      'modi_BabyErr' : 'Only babies with parental relationships can be modified',
      'babyList' : 'Baby List',
      'babyListC' : 'Click to manage the baby.',
      'life_record' : 'Life Record',
      'grow_record' : 'Grow Record',
      'height, weight' : 'height, weight',
      'Infant 0~72 months height percentile' : 'Infant 0~72 months height percentile',
      'Infant 0~72 months weight percentile' : 'Infant 0~72 months weight percentile',
      'male' : 'Male ---',
      'female' : 'Female ---',
      'vaccination' : 'Vaccination',
      'next_vaccination' : 'next vaccination',
      '0~6_months' : '0~6 months',
      '12~35_months' : '12~35 months',
      'ages_4-12' : 'ages 4~12',
      'Vaccination_date' : 'Vaccination date \: ',
      'Recommended_vaccination' : 'Recommend \: ',
      'Recommend_date' : 'Recommend date \: ',
      'Vaccinated' : 'vaccinated',
      'Unvaccinated' : 'unvaccinated',
      'medical_checkup' : 'Medical Check-Up',
      'next_medical_checkup' : 'next medical check-up',
      'timer_explanation' : 'Press and hold the button to start the timer',
      'life0' : 'Mom\'s',
      'life1' : 'Powder',
      'life2' : 'Food',
      'life3' : 'Diaper',
      'life4' : 'Sleep',
      'put_image' : 'attach picture',
      'change_image' : 'change picture',
      'uploaded' : 'Uploaded.',
      'upload' : 'upload',
      'modified' : 'Modified.',
      'q_delete' : 'Do you want delete this diary?',
      'enter_title' : 'Enter title.',
      'title' : 'title',
      'enter_content' : 'Enter content.',
      'content' : 'content',
      'cancel' : 'cancel',
      'New' : 'New',
      'year' : 'Y',
      'month' : 'M',
      'day' : 'Day',
      'day_birth' : '',
      'once_delete' : 'Once delete, you can\'t recover. Do you want to delete?',
      'not_deleted' : 'Not deleted.',
      'homecam' : 'HomeCam',
      'temp' : 'Temp',
      'humid' : 'Humid',
      'new_update' : 'updated',
      'height' : 'Height',
      'weight' : 'Weight',
      'life3_0' : 'ordure',
      'life3_1' : 'urine',
      'memo' : 'Memo',
      'enter_food' : 'Enter timestamp',
      'amount_food' : 'Baby food amount (ml)',
      'babyfood_time' : 'baby food time \:',
      'register_record' : 'Record',
      'enter_sleep' : 'Enter timestamp',
      'sleeping_time' : 'sleeping time \:',
      'enter_hweight' : 'Enter height and weight',
      'select_height' : 'Scroll to select height',
      'select_weight' : 'Scroll to select weight',
      'select_date' : 'Select date to estimate',
      'type_feed' : 'Feeding type',
      'powdered_milk' : 'dry milk',
      'enter_feed' : 'Enter timestamp',
      'amount_feed' : 'Feeding amount(ml)',
      'feeding' : 'Feeding',
      'feeding_time' : 'feeding time \:',
      'dir_feed' : 'Direction of feeding',
      'left' : 'Left',
      'right' : 'Right',
      'Defecation' : 'Defecation',
      'enter_def' : 'Enter timestamp',
      'graph_growth' : 'Growth Statistics',
      'first_growth_record' : 'First enter baby\'s height and weight',
      '\'s growth record' : 's growth record',
      '\'s weight record' : 's weight record',
      'standard_growth' : 'Standard Growth',
      'check_diagram' : 'Check Diagram',
      'vaccine_age' : 'vaccination is by 12 years',
      'temperature_vac' : 'Criteria: Korea Centers for Disease Control and \nPrevention standard vaccination schedule',
      'select_id_invi' : 'Select ID to invite.',
      'select_baby_invi' : 'Select baby.',
      'keep_id' : 'Keep ID format',
      'not_exist_ids' : 'The ID doens\'t exist.',
      'find_exist' : 'Found ID.',
      'license' : 'OSS Notice',
      'warning' : 'Warning',
      'warning_form' : 'Please keep the input form',
      'search_completed': 'Search completed',
      'invitation_complete' : 'Invitation completed',
      'medical_done' : 'Health checkup date',
      'medical_period' : 'Period',
      'finish_previous_check' : 'Finish your previous checkup first',
      'checkup' : 'checkup',
      'noncheckup' : 'noncheckup',
      'check_recommend' : 'Recommended',
      'checkup_done' : 'Checkup done',
      'checkup_finish' : 'Finished checkup',
      'id_input_hint' : 'Please enter your e-mail',
      'pw_input_hint' : 'Please enter 8 to 16 characters for the password.',
      'pwCheck_input_hint' : 'Re-enter password.',
      'name_input_hint' : 'Enter your nickname.',
      'phone_input_hint' : 'Enter your Phone Number',
      'qaType_input_hint' : 'Select the type of question you have set up.',
      'qaAnswer_input_hint' : 'Enter your Phone Answer',
      'babyName_input_hint' : 'Enter the name or nickname of the baby.',
      'babyBirth_input_hint' : 'Enter your baby''s birthday.',

      'qa_val0' : 'Any other email addresses?',
      'qa_val1' : 'What''s your number one treasure?',
      'qa_val2' : 'Where was my elementary school?',
      'qa_val3' : 'What''s your ideal type?',
      'qa_val4' : 'What''s your mother''s name?',
      'qa_val5' : 'What''s your father''s name?',

      'life0_ing' : 'breastfeeding now..',
      'life1_ing' : 'nursing a baby bottle now..',
      'life2_ing' : 'Eating baby food now..',
      'life4_ing' : 'Sleeping now..',

      'pharse_medicalCheck1' : 'Check-up until 71 months before birth',
      'pharse_medicalCheck2' : 'Criteria: National Health Insurance Infant Health \nExamination',
      'change_pw' : 'Change Password',
      'fail_modify' : 'The modification has failed.',

      'vaild_time_range' : "The time range is not valid.",
      'vaild_week' : "The access day is not valid.",
      'vaild_select_baby' : "Select your relationship with the baby you are inviting.",
      'grow_input_warn' : 'Enter height and weight first.',

    }
  };
}