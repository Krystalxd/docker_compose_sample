#1 Указываем на основании какого образа будем билдить наш проект
FROM maven:3.8.4-openjdk-17 as builder

#2 Cоздаем директорию app внутри слоя образа
WORKDIR /app

#3 Копируем все наши папки с текущего проекта в папку app
COPY . /app/.

#4 Запускаем maven, который билдит наш проект и получаем JAR файл
RUN mvn -f /app/pom.xml clean package -Dmaven.test.skip=true

#5 Снова указываем на основании какого образа, мы будем запускать наш проект, здесь уже мы не используем jdk, а только jre - так как нам не нужны инструменты разработчика
FROM eclipse-temurin:17-jre-alpine

#6 Создаем директорию app в новом слое образа.
WORKDIR /app

#7 Копируем с предыдущего слоя с папки target наш JAR в папку app
COPY --from=builder /app/target/*.jar /app/*.jar

#8 Указываем порт
EXPOSE 8181

#9 Запускаем наше приложение в контейнере
ENTRYPOINT ["java", "-jar", "/app/*.jar"]