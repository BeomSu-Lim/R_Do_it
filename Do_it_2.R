gc()                       # garbage collector

#### 6장. 데이터 가공 ####
library(dplyr)
exam <- read.csv("D:/easy_r/Data/csv_exam.csv")
exam

class(exam)
str(exam)
View(exam)

### exam에서 class가 해당 조건인 경우만 추출 (%>% 연산자: Ctrl+Shift+M)
exam %>% filter(class == 1)
exam %>% filter(class == 2)
exam %>% filter(class != 1)
exam %>% filter(class != 3)

exam %>% filter(math > 50)
exam %>% filter(math < 50)
exam %>% filter(english >= 80)
exam %>% filter(english <= 80)

exam %>% filter(class == 1 & math >= 50)
exam %>% filter(class == 2 & english >= 80)

exam %>% filter(math >= 90 | english >= 90)
exam %>% filter(english < 90 | science < 50)

exam %>% filter(class == 1 | class == 3 | class == 5)
exam %>% filter(class %in% c(1,3,5))

class1 <- exam %>% filter(class == 1)
class2 <- exam %>% filter(class == 2)
mean(class1$math)
mean(class2$math)

### 필요한 변수만 추출하기
exam %>% select(math)
exam %>% select(english)
exam %>% select(class, math, english)
exam %>% select(-math)
exam %>% select(-math, -english)

exam %>% filter(class == 1) %>% select(english)
exam %>% 
  filter(class == 1) %>% 
  select(english)

exam %>%
  select(id, math) %>% 
  head

exam %>%
  select(id, math) %>% 
  head(10)

### 순서대로 정렬하기
exam %>% arrange(math)
exam %>% arrange(desc(math))
exam %>% arrange(class, math)

### 파생변수 추가하기
exam %>% 
  mutate(total = math + english + science) %>%    # 총합 변수 추가
  head                                            # 일부 추출

exam %>% 
  mutate(total = math + english + science) %>%    # 총합 변수 추가
  mutate(mean = (math + english + science)/3) %>% # 총평균 변수 추가
  head                                            # 일부 추출

exam %>% 
  mutate(test = ifelse(science >= 60, "pass", "fail")) %>% 
  head

exam %>% 
  mutate(total = math + english + science) %>%
  arrange(total) %>% 
  head

### 집단별로 요약하기
exam %>% 
  summarise(mean_math = mean(math))

str(exam)
exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math))

exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math),
            sum_math = sum(math),
            median_math = median(math),
            n = n())

library(ggplot2)
mpg %>% 
  group_by(manufacturer, drv) %>% 
  summarise(mean_cty = mean(cty)) %>% 
  head(10)

mpg %>% 
  group_by(manufacturer) %>% 
  filter(class == "suv") %>% 
  mutate(tot = (cty+hwy)/2) %>% 
  summarise(mean_tot = mean(tot)) %>% 
  arrange(desc(mean_tot)) %>% 
  head(5)

### 데이터 합치기
## 가로로 합치기
test1 <- data.frame(id = c(1,2,3,4,5), midterm=c(60,80,70,90,85))
test2 <- data.frame(id = c(1,2,3,4,5), final=c(70,83,65,95,80))
test1
test2

ls()
str(test2)

total <- left_join(test1, test2, by="id")
total

## 다른 데이터를 활용해 변수 추가하기
name <- data.frame(class = c(1,2,3,4,5), 
                   teacher=c("kim", "lee", "park", "choi", "jung"))
name
exam_new <- left_join(exam, name, by="class")
exam_new

## 세로로 합치기
group_a <- data.frame(id = c(1,2,3,4,5), test=c(60,80,70,90,85))
group_b <- data.frame(id = c(6,7,8,9,10), test=c(70,83,65,95,80))
group_a
group_b

group_all <- bind_rows(group_a, group_b)
group_all


#### 7장. 데이터 정제 ####
### 결측치 정제하기
df <- data.frame(sex = c("M", "F", NA, "M", "F"),
                 score = c(5, 4, 3, 4, NA))
df

is.data.frame(df)
is.na(df)

table(is.na(df))
table(is.na(df$sex))
table(is.na(df$score))

mean(df$score)
sum(df$score)

## 결측치 제거하기
library(dplyr)
df %>% filter(is.na(score))
df %>% filter(!is.na(score))

df_nomiss <- df %>% filter(!is.na(score))
mean(df_nomiss$score)
sum(df_nomiss$score)

df_nomiss <- df %>% filter(!is.na(score) & !is.na(sex))
df_nomiss

df_nomiss2 <- na.omit(df)          # 변수 지정 없이 결측치 행 제거
df_nomiss2

## 함수의 결측치 제외 기능 이용하기
mean(df$score, na.rm=T)
sum(df$score, na.rm=T)

exam[c(3,8,15), "math"] <- NA      # 3, 8, 15행의 math에 NA 할당
exam

exam %>% summarise(mean_math = mean(math))
exam %>% summarise(mean_math = mean(math, na.rm=T))

exam %>% summarise(mean_math = mean(math, na.rm=T),
                   sum_math = sum(math, na.rm=T),
                   median_math = median(math, na.rm=T))

## 결측치 대체하기 - 평균값으로
mean(exam$math, na.rm=T)
exam$math <- ifelse(is.na(exam$math), 55, exam$math)
table(is.na(exam$math))
exam
mean(exam$math)

### 이상치 정제하기
## 이상치 제거하기: 존재할 수 없는 값
outlier <- data.frame(sex = c(1, 2, 1, 3, 2, 1),
                      score = c(5, 4, 3, 4, 2, 6))
outlier

table(outlier$sex)
table(outlier$score)

outlier$sex <- ifelse(outlier$sex == 3, NA, outlier$sex)
outlier
outlier$score <- ifelse(outlier$score > 5, NA, outlier$score)
outlier

outlier %>% 
  filter(!is.na(sex) & !is.na(score)) %>% 
  group_by(sex) %>% 
  summarise(mean_score = mean(score))

## 이상치 제거하기: 극단적인 값
library(ggplot2)
mpg$hwy
boxplot(mpg$hwy)
boxplot(mpg$hwy)$stats

mpg$hwy <- ifelse(mpg$hwy < 12 | mpg$hwy > 37, NA, mpg$hwy)
table(is.na(mpg$hwy))

mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy, na.rm=T))

#### 8장. 그래프 만들기 ####
### 산점도: 변수 간 관계 표현하기
library(ggplot2)
# 배경 생성
ggplot(data = mpg, aes(x = displ, y = hwy))
# 산점도 추가
ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_point()
# x축 범위 지정
ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_point() + xlim(3, 6)
# x축, y축 범위 지정
ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_point() + xlim(3, 6) + ylim(10, 30)

### 막대 그래프: 집단 간 차이 표현하기
library(dplyr)

# 집단별 평균표 만들기
df_mpg <- mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy))
df_mpg

# 그래프 생성
ggplot(data = df_mpg, aes(x = drv, y = mean_hwy)) + geom_col()
# 크기 순 정렬
ggplot(data = df_mpg, aes(x = reorder(drv, -mean_hwy), y = mean_hwy)) + 
  geom_col()

## 빈도 막대 그래프 만들기
ggplot(data = mpg, aes(x = drv)) + geom_bar()
ggplot(data = mpg, aes(x = hwy)) + geom_bar()

### 선 그래프: 시간에 따라 달라지는 데이터 표현
ggplot(data = economics, aes(x = date, y = unemploy)) + geom_line()

### 상자 그림: 집단 간 분포 차이 표현하기
ggplot(data = mpg, aes(x = drv, y = hwy)) + geom_boxplot()

