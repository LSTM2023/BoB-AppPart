# 👶 BOB : Best Of Baby 👶

## 2023 공개 SW 개발자대회

> 대회 웹사이트: https://www.oss-registration.kr/ <br>
> 시연 영상: Coming Soon! <br>

<img width="232" alt="image" src="https://github.com/LSTM2023/BoB-AppPart/assets/87134427/8538e986-f09b-44af-b44a-16a57ada4127">

## 개발 배경

1. 육아 기록 및 건강 관리가 가능한 스마트 육아 수첩의 필요성
2. 수면 중 갑작스럽게 사망하는 영아 돌연사 증후군 예방

  &Rightarrow; &nbsp; 생활 기록 및 홈캠을 이용한 수면 자세 판별 기능을 제공하여 부모들의 육아 스트레스를 줄여주는 통합 육아 수첩 애플리케이션을 개발하고자 함

## 주요 기능

- 홈캠 및 온습도 센서를 통한 아이 수면 실시간 모니터링
  
- 딥러닝 기반 수면 자세 포즈 추정 및 비정상 수면 자세 알림 서비스
- 수유, 이유식, 수면 시간 등을 기록할 수 있는 편리한 방식의 생활 기록 서비스
- 키, 몸무게를 기록하여 아이의 발달 상태를 한 눈에 그래프로 확인할 수 있는 성장 기록 서비스
- 질병 관리청의 정보를 기반으로 한 건강 검진, 예방 접종 관리
- 가족, 베이비시터 등 부모 외 공동 양육자와 함께 편리하게 아이 정보를 관리할 수 있도록 하는 공동 육아 서비스
- 아이에 대한 그날의 추억을 사진과 함께 담아낼 수 있는 육아 일기

## 팀원

| 팀원                                          | 역할                                     |
|:--------------------------------------------| :--------------------------------------- |
| 😆 [노승하(PM)](https://github.com/seungha164) | Frontend App (with Flutter) |
| :wink: [김정효](https://github.com/jjanghyo)       | Frontend App (with Flutter) |
| 😊 [홍찬의](https://github.com/hcu55)          | Frontend App (with Flutter) |
| 😎 [임원빈](https://github.com/Mmm2927)        | Backend (with Django, PostgreSQL, Azure, CI/CD) |
| :grin: [피선우](https://github.com/SunWoo98Pi)     | AI/DL Pose Estimation (with Ultralytics) & Raspberry Pi |
| :smile: 민동현          | UI Design & Video Production |

---
## 🚀 Stacks
### Infra
<p>
  <img height=27em src="https://img.shields.io/badge/Raspberry Pi-A22846?style=flat&logo=Raspberry Pi&logoColor=white"/></a>&nbsp
  <img height=27em src="https://img.shields.io/badge/Amazon EC2-FF9900?style=flat&logo=Amazon EC2&logoColor=white"/></a>&nbsp
  <img height=27em src="https://img.shields.io/badge/Firebase Cloud Messaging-FFCA28?style=flat&logo=Firebase&logoColor=white"/></a>&nbsp
  <img height=27em src="https://img.shields.io/badge/Docker-2496ED?style=flat&logo=Docker&logoColor=white"/></a>&nbsp
</p>

### Database(DB)
<p>
  <img height=27em src="https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=PostgreSQL&logoColor=white"/></a>&nbsp
</p>

### Frameworks
<p>
  <img height=27em src="https://img.shields.io/badge/Django-092E20?style=flat&logo=Django&logoColor=white"/></a>&nbsp
  <img height=27em src="https://img.shields.io/badge/Flutter-02569B?style=flat&logo=Flutter&logoColor=white"/></a>&nbsp
</p>

### AI/DL
<p>
  <img height=27em src="https://img.shields.io/badge/PyTorch-EE4C2C?style=flat&logo=PyTorch&logoColor=white"/></a>&nbsp
  <img height=27em src="https://img.shields.io/badge/Ultralytics(YOLO)-071D49?style=flat&logo=YOLO&logoColor=white"/></a>
</p>

## 📀 System Structure
![System Structure](https://github.com/LSTM2023/BoB-AppPart/assets/99634832/900705e5-b8bc-4273-ad0a-3b87de79a058)




## :link: Library Licenses
- V4L2rtspserver : for Home CAM Streaming using RTSP Protocol
  - https://github.com/mpromonet/v4l2rtspserver
- Ultralytics : for Deep Learning Pose Estimation
  - https://github.com/ultralytics/ultralytics
- SyRIP : for Fine-Tuning YOLOv8 Pose Estimation Model
  - https://github.com/ostadabbas/Infant-Pose-Estimation
