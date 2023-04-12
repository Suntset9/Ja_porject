### 第一章 初识SpringMVC

#### 1.1 SpringMVC概述

- SpringMVC是Spring子框架

- SpringMVC是Spring 为**【展现层|表示层|表述层|控制层】**提供的基于 MVC 设计理念的优秀的 Web 框架，是目前最主流的MVC 框架。

- SpringMVC是非侵入式：可以使用注解让普通java对象，作为**请求处理器【Controller】**。

- SpringMVC是用来代替Servlet

  > Servlet作用
  >
  >  	1. 处理请求
  >       - 将数据共享到域中
  >  	2. 做出响应
  >       - 跳转页面【视图】

#### 1.2 SpringMVC处理请求原理简图

- 请求
- DispatcherServlet【前端控制器】
  - 将请求交给Controller|Handler
- Controller|Handler【请求处理器】
  - 处理请求
  - 返回数据模型
- ModelAndView
  - Model：数据模型
  - View：视图对象或视图名
- DispatcherServlet渲染视图
  - 将数据共享到域中
  - 跳转页面【视图】
- 响应

![image-20220330160253730](04_SpringMVC.assets\image-20220330160253730.png)

### 第二章 SpringMVC搭建框架

#### 2.1 搭建SpringMVC框架

- 创建工程【web工程】

- 导入jar包

  ```xml
  <!--spring-webmvc-->
  <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
      <version>5.3.1</version>
  </dependency>
  
  <!-- 导入thymeleaf与spring5的整合包 -->
  <dependency>
      <groupId>org.thymeleaf</groupId>
      <artifactId>thymeleaf-spring5</artifactId>
      <version>3.0.12.RELEASE</version>
  </dependency>
  
  <!--servlet-api-->
  <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>4.0.1</version>
      <scope>provided</scope>
  </dependency>
  ```

- 编写配置文件

  - **web.xml注册DispatcherServlet**
    - url配置：/
    - init-param:contextConfigLocation，设置springmvc.xml配置文件路径【管理容器对象】
    - \<load-on-startup>：设置DispatcherServlet优先级【启动服务器时，创建当前Servlet对象】
  - **springmvc.xml**
    - 开启组件扫描
    - 配置视图解析器【解析视图（设置视图前缀&后缀）】

- 编写请求处理器【Controller|Handler】
  - 使用**@Controller**注解标识请求处理器
  - 使用**@RequestMapping**注解标识处理方法【URL】
- 准备页面进行，测试



