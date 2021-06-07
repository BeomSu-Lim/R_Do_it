###### Do it! 쉽게 배우는 R 데이터 분석 ######
### 2장. 분석환경 만들기
## 계산 및 변수 테스트
4+5
4*5
9/3

a <- 1
b <- 2

## 프로젝트(.Rproj) 만들기

#### 3장. 데이터 분석 기본 개념 ####
### 3-1장. 변수 
a <- 1
a

b <- 2; b

c <- 3; c

d <- 3.5; d

a+b
a+b+c
4/b
5*b

var1 <- c(1,2,5,7,8)       # combine() 함수
var1
var1+2

var2 <- c(1:5) 
var2
var1+var2

var3 <- seq(1, 5)
var3

var4 <- seq(1, 10, by=2)
var4

var5 <- seq(1, 10, by=3)
var5

str1 <- "a"
str1

str2 <- "text"
str2
str1+str2        # 문자로 된 변수는 연산 불가능
class(str2)
typeof(str2)

t <- 'abc'
t
class(t)
typeof(t)

str3 <- 'Hello World!'
str3

t2 <- 'Hello,
World!'
t2

str4 <- c("a", "b", "c")
str4
class(str4)

str5 <- c("Hello!", "World", "is", "good!")
str5
class(str5)
ls()


### 3-2장. 함수
x <- c(1,2,3)
x

mean(x)
max(x)
min(x)

str5
paste(str5, collapse = ",")
paste(str5, collapse = " ")

x_mean <- mean(x)
x_mean

str5_paste <- paste(str5, collapse = " ")
str5_paste
print(str5_paste)


### 3-3장. 패키지
#install.packages("ggplot2")
library(ggplot2)

x <- c("a", "a", "b", "c")
qplot(x)

## mpg 데이터 세트를 활용
# x축에 hwy 변수
qplot(data = mpg, x = hwy)
# x축에 cty 변수
qplot(data = mpg, x = cty)
# x축 drv, y축 hwy
qplot(data = mpg, x = drv, y = hwy)
# x축 drv, y축 hwy, 선 그래프 형태
qplot(data = mpg, x = drv, y = hwy, geom = "line")
# x축 drv, y축 hwy, 상자 그림 형태
qplot(data = mpg, x = drv, y = hwy, geom = "boxplot")
# x축 drv, y축 hwy, 상자 그림 형태, drv별 색 표현
qplot(data = mpg, x = drv, y = hwy, geom = "boxplot", colour = drv)

# qplot 함수 매뉴얼 출력
?qplot


#### 4장. 데이터 프레임 ####
## 변수 만들기
english <- c(90, 80, 60, 70)    # 영어 점수 변수 생성
english

math <- c(50, 60, 100, 20)      # 수학 점수 변수 생성
math

## 데이터 프레임 만들기
df_midterm <- data.frame(english, math)
df_midterm

## 반의 정보가 추가된 데이터 프레임
class <- c(1, 1, 2, 2)
df_midterm <- data.frame(english, math, class)
df_midterm

## 분석하기
mean(df_midterm$english)
mean(df_midterm$math)

## 데이터 프레임 한번에 만들기
df_midterm <- data.frame(english = c(90, 80, 60, 70),
                         math = c(50, 60, 100, 20),
                         class = c(1, 1, 2, 2))
df_midterm

### 외부 데이터 이용하기
#install.packages("readxl")
library(readxl)

# 엑셀 파일 불러오기
df_exam <- read_excel("D:/easy_r/Data/excel_exam.xlsx")
df_exam

# 분석하기
mean(df_exam$english)
mean(df_exam$science)

## 첫 번째 행을 변수명이 아닌 데이터로 인식
df_exam_novar <- read_excel("D:/easy_r/Data/excel_exam_novar.xlsx",
                            col_names = F)
df_exam_novar

## Excel 파일에 Sheet가 여러 개 있다면?
df_exam_sheet <- read_excel("D:/easy_r/Data/excel_exam_sheet.xlsx", sheet=3)
df_exam_sheet

## csv 파일 불러오기
df_csv_exam <- read.csv("D:/easy_r/Data/csv_exam.csv")
df_csv_exam

## 데이터 프레임을 csv 파일로 저장하기
df_midterm <- data.frame(english = c(90, 80, 60, 70),
                         math = c(50, 60, 100, 20),
                         class = c(1, 1, 2, 2))
df_midterm

write.csv(df_midterm, file="df_midterm.csv")
dir()                  # 파일 생성 경로 확인

## RDS 파일(R 전용 파일) 활용하기
## 데이터 프레임을 .rds 파일로 저장
saveRDS(df_midterm, file="df_midterm.rds")

# RDS 파일 불러오기
rm(df_midterm)         # 앞에서 만든 df_midterm 삭제(ReMove)

df_midterm <- readRDS("df_midterm.rds")
df_midterm


#### 5장. 데이터 분석 기초 ####
## 데이터 파악하기 - exam.csv
exam <- read.csv("D:/easy_r/Data/csv_exam.csv")
exam

# head(): 데이터 앞부분 파악하기
head(exam)
head(exam, n=7)
head(exam, 10)
# tail(): 데이터 뒷부분 파악하기
tail(exam)
tail(exam, 10)
# View(): 데이터 뷰어 창에서 exam 데이터 확인 (반드시 대문자 V 사용)
View(exam)
# dim(): 데이터가 몇 행, 몇 열로 구성되어 있는지 알아보기
dim(exam)
# str(): 데이터 속성 파악하기
str(exam)
# summary(): 요약 통계량 산출하기
summary(exam)

## mpg 데이터 파악하기
library(ggplot2)

ggplot2::mpg
class(ggplot2::mpg)

mpg <- as.data.frame(ggplot2::mpg)
head(mpg)
tail(mpg)
View(mpg)
dim(mpg)
str(mpg)
summary(mpg)

?mpg

### 변수명 바꾸기
df_raw <- data.frame(var1 = c(1, 2, 1), 
                     var2 = c(2, 3, 2))
df_raw
class(df_raw)       # 데이터 타입 확인

#install.packages("dplyr")
library(dplyr)

df_new <- df_raw                       # 복사본 생성
df_new

# 식별자에 반드시 할당해줘야 적용됨
df_new <- rename(df_new, v2 = var2)    # 변수명 var2를 v2로 수정
df_new

df_raw
df_new

### 파생변수 만들기
df <- data.frame(var1 = c(4, 3, 8),
                 var2 = c(2, 6, 1))
df

# var_sum, var_mean이라는 파생변수 생성
df$var_sum <- df$var1 + df$var2
df

str(df)
df$var_mean <- (df$var1 + df$var2)/2
df

#
c <- df$var1 + df$var2    # var의 합을 c라는 변수에 할당
c                         # 출력
(c <- df$var1 + df$var2)  # 변수에 할당한 즉시 출력

class(c)

## mpg 통합 연비 변수 만들기
library(ggplot2)
ggplot2::mpg
class(ggplot2::mpg)
mpg <- as.data.frame(ggplot2::mpg)
class(mpg)

mpg$total <- (mpg$cty + mpg$hwy)/2
head(mpg)
mean(mpg$total)

## 조건문을 활용한 파생변수 생성
summary(mpg$total)         # 요약통계량 산출
hist(mpg$total)            # 히스토그램 생성

# total이 20 이상이면 pass, 아니라면 fail 부여
mpg$test <- ifelse(mpg$total >= 20, "pass", "fail")
tail(mpg, 15)

# 막대그래프로 빈도 표현하기
library(ggplot2)
qplot(mpg$test)

## 중첩 조건문: A, B, C 등급 부여
mpg$grade <- ifelse(mpg$total >= 30, "A", 
                    ifelse(mpg$total >= 20, "B", "C"))
tail(mpg, 15)

# 빈도표, 막대 그래프로 연비 등급 살펴보기
table(mpg$grade)         # 등급 빈도표
qplot(mpg$grade)         # 등급 빈도 막대 그래프

# 원하는 만큼 범주 만들기
mpg$grade2 <- ifelse(mpg$total >= 30, "A", 
                     ifelse(mpg$total >= 25, "B", 
                            ifelse(mpg$total >= 20, "C", "D")))
tail(mpg, 10)

