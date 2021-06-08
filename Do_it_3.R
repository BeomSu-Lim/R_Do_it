#### 10장. 텍스트 마이닝 ####
## R KoNLP 설치 및 확인
install.packages("multilinguer")
library(multilinguer)

install_jdk()
install.packages(c("stringr", "hash", "tau", "Sejong", "RSQLite", "devtools"), type = "binary")
install.packages("remotes")
remotes::install_github("haven-jeon/KoNLP",  upgrade = "never",  INSTALL_opts=c("--no-multiarch"))

library(KoNLP)
# 세종 사전 사용 지정
useSejongDic( ) 

## ----------------------------------------------------------------------- ##

#extractNoun  함수 공백을 기준으로 단어 판단
v1 <- c("봄이 지나면 여름이고 여름이 지나면 가을입니다. 그리고 겨울이죠")
extractNoun(v1)

#### 10-1: 힙합 가사 텍스트 마이닝 ####
dir()
## -------------------------------------------------------------------- ##
# 패키지 설치
#install.packages("rJava")
#install.packages("memoise")
#install.packages("stringr")
#install.packages("wordcloud")

#기본R 에서 실행시 실행경로 설정
#setwd('C:/Users/Admin/Desktop/ML_Developer/R/R_강의교안/02_교안/10_텍스트마이닝_R_GUI_실행_권장/교재_실습_소스')

# 패키지 로드
#library(KoNLP)
library(dplyr)

# 사전 설정하기
useNIADic()

# 데이터 불러오기
txt <- readLines("hiphop.txt")
class(txt)
head(txt)


library(stringr)

# 특수문자 제거
txt <- str_replace_all(txt, "\\W", " ")


## -------------------------------------------------------------------- ##
# extractNoun() 함수: 문장에서 명사를 추출
extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다")

# 가사에서 명사추출
nouns <- extractNoun(txt)

# 추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns))

# 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)

# 변수명 수정
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

# 두 글자 이상 단어 추출
df_word <- filter(df_word, nchar(word) >= 2)

top_20 <- df_word %>%
  arrange(desc(freq)) %>%
  head(20)

top_20


## -------------------------------------------------------------------- ##
# 패키지 로드
# wordcloud() 함수: R GUI에서 실행하는 것을 추천
library(wordcloud)
library(RColorBrewer)

pal <- brewer.pal(8,"Dark2")  # Dark2 색상 목록에서 8개 색상 추출
pal

# 워드 클라우드 만들기
#par(mar=c(0.1,0.1,0.1,0.1))
set.seed(1234)
wordcloud(words = df_word$word,  # 단어
          freq = df_word$freq,   # 빈도
          min.freq = 2,          # 최소 단어 빈도
          max.words = 200,       # 표현 단어 수
          random.order = F,      # 고빈도 단어 중앙 배치
          rot.per = .1,          # 회전 단어 비율
          scale = c(4, 0.3),     # 단어 크기 범위
          colors = pal)          # 색깔 목록
savePlot("w1.png", type="png")

# 단어 색상 바꾸기
pal <- brewer.pal(9,"Blues")[5:9]  # 색상 목록 생성
set.seed(1234)                     # 난수 고정
wordcloud(words = df_word$word,    # 단어
          freq = df_word$freq,     # 빈도
          min.freq = 10,           # 최소 단어 빈도
          max.words = 200,         # 표현 단어 수
          random.order = F,        # 고빈도 단어 중앙 배치
          rot.per = .1,            # 회전 단어 비율
          scale = c(4, 0.3),       # 단어 크기 범위
          colors = pal)            # 색상 목록

setwd("D:/easy_r")
dir()


#### 10-2: 국정원 트윗 텍스트 마이닝 ####
#기본R 에서 실행시 실행경로 설정
#setwd('C:/Users/Admin/Desktop/ML_Developer/R/R_강의교안/02_교안/10_텍스트마이닝_R_GUI_실행_권장/교재_실습_소스')

# 패키지 로드
library(KoNLP)
library(dplyr)

useNIADic()

## -------------------------------------------------------------------- ##
# 데이터 로드
twitter <- read.csv("twitter.csv",
                    header = T,
                    stringsAsFactors = F,
                    fileEncoding = "UTF-8")

# 변수명 수정
twitter <- rename(twitter,
                  no = 번호,
                  id = 계정이름,
                  date = 작성일,
                  tw = 내용)

# 특수문자 제거
twitter$tw <- str_replace_all(twitter$tw, "\\W", " ")
head(twitter$tw)

library(stringr)
str_replace(
  twitter$tw, "\\W", " "
)
str_replace(
  twitter$tw, "RT", " "
)
head(twitter$tw)

# 트윗에서 명사추출
nouns <- extractNoun(twitter$tw)

# 추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns))

# 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)

# 변수명 수정
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)


# 두 글자 이상 단어만 추출
library(dplyr)
df_word <- filter(df_word, nchar(word) >= 2)

# 상위 20개 추출
top20 <- df_word %>%
  arrange(desc(freq)) %>%
  head(20)

top20

## 단어 빈도 막대 그래프 생성
library(ggplot2)

order <- arrange(top20, freq)$word              # 빈도 순서 변수 생성

ggplot(data = top20, aes(x = word, y = freq)) + 
  ylim(0, 2500) +
  geom_col() + 
  coord_flip() +
  scale_x_discrete(limit = order) +             # 빈도 순서 변수 기준 막대 정렬
  geom_text(aes(label = freq), hjust = -0.3)    # 빈도 표시

## 워드 클라우드 생성
pal <- brewer.pal(8,"Dark2")       # 색상 목록 생성
set.seed(1234)                     # 난수 고정

wordcloud(words = df_word$word,    # 단어
          freq = df_word$freq,     # 빈도
          min.freq = 10,           # 최소 단어 빈도
          max.words = 200,         # 표현 단어 수
          random.order = F,        # 고빈도 단어 중앙 배치
          rot.per = .1,            # 회전 단어 비율
          scale = c(6, 0.2),       # 단어 크기 범위
          colors = pal)            # 색상 목록

pal <- brewer.pal(9,"Blues")[5:9]  # 색상 목록 생성
set.seed(1234)                     # 난수 고정

wordcloud(words = df_word$word,    # 단어
          freq = df_word$freq,     # 빈도
          min.freq = 10,           # 최소 단어 빈도
          max.words = 200,         # 표현 단어 수
          random.order = F,        # 고빈도 단어 중앙 배치
          rot.per = .1,            # 회전 단어 비율
          scale = c(6, 0.2),       # 단어 크기 범위
          colors = pal)            # 색상 목록


#### 11장. 지도 시각화 ####
ls()
rm(list=ls())    # 이전 데이터 삭제
ls()

### 11-1. 미국 주별 강력 범죄율 단계 구분도 만들기
# 패키지 준비
install.packages("mapproj")
install.packages("ggiraphExtra")
library(mapproj)
library(ggiraphExtra)

# 미국 주별 범죄 데이터 준비
str(USArrests)
head(USArrests)

# state의 값을 소문자로 수정
library(tibble)
crime <- rownames_to_column(USArrests, var = "state")
crime$state <- tolower(crime$state)
View(crime)
str(crime)

# 미국 주 지도 데이터 준비
install.packages("maps")
library(maps)
library(ggplot2)

states_map <- map_data("state")     # 미국 주 위도, 경도
str(states_map)

# 단계 구분도 만들기
library(ggiraphExtra)
ggChoropleth(data = crime,          # 지도에 표현할 데이터
             aes(fill = Murder,     # 색깔로 표현할 변수
                 map_id = state),   # 지역 기준 변수
             map = states_map)      # 지도 데이터

# 인터랙티브 단계 구분도 만들기
ggChoropleth(data = crime,          # 지도에 표현할 데이터
             aes(fill = Murder,     # 색깔로 표현할 변수
                 map_id = state),   # 지역 기준 변수
             map = states_map,      # 지도 데이터
             interactive = T)       # 인터랙티브

### 11-2. 대한민국 시도별 인구, 결핵 환자 수 단계 구분도
# 패키지 준비
install.packages("stringi")
install.packages("devtools")
devtools::install_github("cardiomoon/kormaps2014")
library(kormaps2014)

# 데이터 준비
str(changeCode(korpop1))

library(dplyr)
class(korpop1)
# 인코딩 변경
korpop1 <- rename(korpop1, pop = 총인구_명, name = 행정구역별_읍면동)
korpop1$name <- iconv(korpop1$name, "UTF-8", "CP949")
str(korpop1)

str(changeCode(kormap1))

# 단계 구분도 만들기
ggChoropleth(data = korpop1,
             aes(fill = pop,
                 map_id = code,
                 tooltip = name),
             map = kormap1,
             interactive = T)

## 대한민국 시도별 결핵 환자 수 단계 구분도
str(changeCode(tbc))

tbc$name <- iconv(tbc$name, "UTF-8", "CP949")
ggChoropleth(data = tbc,
             aes(fill = NewPts,
                 map_id = code,
                 tooltip = name),
             map = kormap1,
             interactive = T)

#### (+) 구글 지도 차트 실습 ####
install.packages("googleVis")
library(googleVis)

data(Andrew)
Andrew
class(Andrew)
str(Andrew)
head(Andrew)

# 데이터프레임, 위도:경도, 요약정보
storm1 <- gvisMap(Andrew, "LatLong", "Tip",
                  options=list(showTip=TRUE, showLine=TRUE, 
                               enableScrollWheel=TRUE,
                               mapType='hybrid', useMapTypeControl=TRUE,
                               width=800, height=400))
class(storm1)
plot(storm1)

## ---------------------------------------------------------------------- ##

loc <- read.csv("서울시구청위치정보_new.csv", header=T)
loc
class(loc)
str(loc)
head(loc)

# 데이터프레임, 위도:경도, 요약정보
hoffice <- gvisMap(loc, "LATLON" , "name",
                   options=list(showTip=TRUE, showLine=TRUE, 
                                enableScrollWheel=TRUE,
                                mapType='normal', useMapTypeControl=TRUE,
                                width=1000, height=400))
plot(hoffice)
