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

### 第三章 @RequestMapping详解

> @RequestMapping注解作用：为指定的类或方法设置相应URL

#### 3.1 @RequestMapping注解位置

- 书写在类上面
  - 作用：为当前类设置映射URL
  - 注意：不能单独使用，需要与方法上的@RequestMapping配合使用
- 书写在方法上面
  - 作用：为当前方法设置映射URL
  - 注意：可以单独使用

#### 3.2 @RequestMapping注解属性

- value属性

  - 类型：String[]
  - 作用：设置URL信息

- path属性

  - 类型：String[]
  - 作用：与value属性作用一致

- method属性

  - 类型：RequestMethod[]

    > ```java
    > public enum RequestMethod {
    >    GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS, TRACE
    > }
    > ```

  - 作用：为当前URL【类或方法】设置请求方式【POST、DELETE、PUT、GET】

  - 注意：

    - 默认情况：所有请求方式均支持
    - 如请求方式不支持，会报如下错误
      -  405【Request method 'GET' not supported】

- params

  - 类型：String[]
  - 作用：为当前URL设置请求参数
  - 注意：如设置指定请求参数，但URL中未携带指定参数，会报如下错误
    - 400【Parameter conditions "lastName" not met for actual request parameters:】

- headers

  - 类型：String[]
  - 作用：为当前URL设置请求头信息
  - 注意：如设置指定请求头，但URL中未携带请求头，会报如下错误
    - 404：请求资源未找到

- 示例代码

  ```java
  @RequestMapping(value = {"/saveEmp","/insertEmp"},
                  method = RequestMethod.GET,
                  params = "lastName=lisi",
                  headers = "User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36")
  public String saveEmp(){
      System.out.println("添加员工信息！！！！");
  
      return SUCCESS;
  }
  ```

#### 3.3 @RequestMapping支持Ant 风格的路径（了解）

- #### 常用通配符

  a) ?：匹配一个字符

  b) *：匹配任意字符

  c) **：匹配多层路径 

- 示例代码

  ```java
  @RequestMapping("/testAnt/**")
  public String testAnt(){
      System.out.println("==>testAnt!!!");
      return SUCCESS;
  }
  ```

### 第四章 @PathVariable 注解

#### 4.1 @PathVariable注解位置

> ```
> @Target(ElementType.PARAMETER)
> ```

- 书写在参数前面

#### 4.2 @PathVariable注解作用

- 获取URL中占位符参数

- 占位符语法：{}

- 示例代码

  ```html
  <a th:href="@{/EmpController/testPathVariable/1001}">测试PathVariable注解</a><br>
  ```

  ```java
  /**
   * testPathVariable
   * @return
   */
  @RequestMapping("/testPathVariable/{empId}")
  public String testPathVariable(@PathVariable("empId") Integer empId){
      System.out.println("empId = " + empId);
      return SUCCESS;
  }
  ```

#### 4.3 @PathVariable注解属性

- value属性
  - 类型：String
  - 作用：设置占位符中的参数名
- name属性
  - 类型：String 
  - 作用：与name属性的作用一致
- required属性
  - 类型：boolean
  - 作用：设置当前参数是否必须入参【默认值：true】
    - true：表示当前参数必须入参，如未入参会报如下错误
      -  Missing URI template variable 'empId' for method parameter of type Integer
    - false：表示当前参数不必须入参，如未入参，会装配null值

### 第五章 REST【RESTful】风格CRUD

#### 5.1 REST的CRUD与传统风格CRUD对比

- 传统风格CRUD
  - 功能 						URL															请求方式
  - 增                             /insertEmp			       						    POST
  - 删                             /deleteEmp?empId=1001                      GET
  - 改                             /updateEmp                                             POST
  - 查                             /selectEmp?empId=1001                       GET

- REST风格CRUD
  - 功能 						URL															请求方式
  - 增                             /emp			       						               **POST**
  - 删                             /emp/1001                                                **DELETE**
  - 改                             /emp                                                          **PUT**
  - 查                             /emp/1001                                                **GET**

#### 5.2 REST风格CRUD优势

- 提高网站排名
  - 排名方式
    - **竞价排名**
    - 技术排名
- 便于第三方平台对接

#### 5.3 实现PUT&DELETE提交方式步骤

- 注册过滤器HiddenHttpMethodFilter
- 设置表单的提交方式为POST
- 设置参数：\_method=PUT或\_method=DELETE

#### 5.4 源码解析HiddenHttpMethodFilter

```java
public static final String DEFAULT_METHOD_PARAM = "_method";

private String methodParam = DEFAULT_METHOD_PARAM;

@Override
protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
      throws ServletException, IOException {

   HttpServletRequest requestToUse = request;

   if ("POST".equals(request.getMethod()) && request.getAttribute(WebUtils.ERROR_EXCEPTION_ATTRIBUTE) == null) {
      String paramValue = request.getParameter(this.methodParam);
      if (StringUtils.hasLength(paramValue)) {
         String method = paramValue.toUpperCase(Locale.ENGLISH);
         if (ALLOWED_METHODS.contains(method)) {
            requestToUse = new HttpMethodRequestWrapper(request, method);
         }
      }
   }

   filterChain.doFilter(requestToUse, response);
}
/**
	 * Simple {@link HttpServletRequest} wrapper that returns the supplied method for
	 * {@link HttpServletRequest#getMethod()}.
	 */
	private static class HttpMethodRequestWrapper extends HttpServletRequestWrapper {

		private final String method;

		public HttpMethodRequestWrapper(HttpServletRequest request, String method) {
			super(request);
			this.method = method;
		}

		@Override
		public String getMethod() {
			return this.method;
		}
	}
```

### 第六章 SpringMVC处理请求数据

> 使用Servlet处理请求数据
>
> 1. 请求参数
>    - String param = request.getParameter();
> 2. 请求头
>    - request.getHeader();
> 3. Cookie
>    - request.getCookies();

#### 6.1 处理请求参数

- 默认情况：可以将请求参数名，与入参参数名一致的参数，自动入参【自动类型转换】

- SpringMVC支持POJO入参

  - 要求：请求参数名与POJO的属性名保持一致

  - 示例代码

    ```html
    <form th:action="@{/saveEmp}" method="POST">
        id:<input type="text" name="id"><br>
        LastName:<input type="text" name="lastName"><br>
        Email:<input type="text" name="email"><br>
        Salary:<input type="text" name="salary"><br>
        <input type="submit" value="添加员工信息">
    </form>
    ```

    ```java
    /**
     * 获取请求参数POJO
     * @return
     */
    @RequestMapping(value = "/saveEmp",method = RequestMethod.POST)
    public String saveEmp(Employee employee){
        System.out.println("employee = " + employee);
        return  SUCCESS;
    }
    ```

- @RequestParam注解

  - 作用：如请求参数与入参参数名不一致时，可以使用@RequestParam注解设置入参参数名

  - 属性

    - value
      - 类型：String
      - 作用：设置需要入参的参数名
    - name
      - 类型：String
      - 作用：与value属性作用一致
    - required
      - 类型：Boolean
      - 作用：设置当前参数，是否必须入参
        - true：表示当前参数必须入参，如未入参会报如下错误
          - 400【Required String parameter 'sName' is not present】
        - false：表示当前参数不必须入参，如未入参，装配null值
    - defaultValue
      - 类型：String
      - 作用：当装配数值为null时，指定当前defaultValue默认值

  - 示例代码

    ```java
    /**
     * 获取请求参数
     * @return
     */
    @RequestMapping("/requestParam1")
    public String requestParam1(@RequestParam(value = "sName",required = false,
                                            defaultValue = "zhangsan")
                                            String stuName,
                                Integer stuAge){
        System.out.println("stuName = " + stuName);
        System.out.println("stuAge = " + stuAge);
        return SUCCESS;
    }
    ```

#### 6.2 处理请头

- 语法：**@RequestHeader注解**

- 属性

  - value
    - 类型：String
    - 作用：设置需要获取请求头名称
  - name
    - 类型：String
    - 作用：与value属性作用一致
  - required
    - 类型：boolean
    - 作用：【默认值true】
      - true：设置当前请求头是否为必须入参，如未入参会报如下错误
        - 400【Required String parameter 'sName' is not present】
      - false：表示当前参数不必须入参，如未入参，装配null值
  - defaultValue
    - 类型：String
    - 作用：当装配数值为null时，指定当前defaultValue默认值

- 示例代码

  ```html
  <a th:href="@{/testGetHeader}">测试获取请求头</a>
  ```

  ```java
  /**
   * 获取请求头
   * @return
   */
  @RequestMapping(value = "/testGetHeader")
  public String testGetHeader(@RequestHeader("Accept-Language")String al,
                              @RequestHeader("Referer") String ref){
      System.out.println("al = " + al);
      System.out.println("ref = " + ref);
      return SUCCESS;
  }
  ```

#### 6.3 处理Cookie信息

- 语法：@CookieValue获取Cookie数值

- 属性

  - value
    - 类型：String
    - 作用：设置需要获取Cookie名称
  - name
    - 类型：String
    - 作用：与value属性作用一致
  - required
    - 类型：boolean
    - 作用：【默认值true】
      - true：设置当前Cookie是否为必须入参，如未入参会报如下错误
        - 400【Required String parameter 'sName' is not present】
      - false：表示当前Cookie不必须入参，如未入参，装配null值
  - defaultValue
    - 类型：String
    - 作用：当装配数值为null时，指定当前defaultValue默认值

- 示例代码

  ```html
  <a th:href="@{/setCookie}">设置Cookie信息</a><br>
  <a th:href="@{/getCookie}">获取Cookie信息</a><br>
  ```

  ```java
  /**
       * 设置Cookie
       * @return
       */
      @RequestMapping("/setCookie")
      public String setCookie(HttpSession session){
  //        Cookie cookie = new Cookie();
          System.out.println("session.getId() = " + session.getId());
          return SUCCESS;
      }
  
      /**
       * 获取Cookie
       * @return
       */
      @RequestMapping("/getCookie")
      public String getCookie(@CookieValue("JSESSIONID")String cookieValue){
          System.out.println("cookieValue = " + cookieValue);
          return SUCCESS;
      }
  ```

#### 6.4 使用原生Servlet-API

- 将原生Servlet相关对象，入参即可





### 第七章 SpringMVC处理响应数据





























































