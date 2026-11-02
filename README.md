# asr-hw1

0010517 음성인식입문 (Intro to ASR) 과제 #1: UrbanSound8K로 K-Means, GMM의 학습 및 테스트 결과를 작성하여 PDF로 제출합니다.

진행 계획은 [plan.md](plan.md)에 있습니다.

## 시작하기

데이터(약 6.6GB)는 저장소에 포함되어 있지 않습니다. 새 환경에서는 먼저 다음을 실행합니다.

```bash
scripts/setup_data.sh
```

압축 파일 6GB를 내려받아 MD5를 검증하고, `TF_PatternRecognition/data/`에 배치합니다. 압축 파일과 특징 파일까지 고려하면 여유 공간이 20GB 이상 필요합니다.

## 구성

- `TF_PatternRecognition/`: 실습 코드. [IMPRESS-LAB/TF_PatternRecognition](https://github.com/IMPRESS-LAB/TF_PatternRecognition)의 커밋 `0d40d35`를 가져왔습니다.
- `docs/`: 강의 전사본과 과제 안내
- `scripts/`: 데이터 설치 스크립트
- `logs/`, `results/`, `report/`: 진행하면서 생성되는 실행 로그, 결과 표, 보고서

## 라이선스

실습 코드의 저작권은 IMPRESS LAB에 있습니다. UrbanSound8K는 비상업적 이용만 허용됩니다(CC BY-NC). 수업 자료가 포함되어 있으므로 비공개로 유지합니다.
