### 第一章 初识Spring

#### 1.1 Spring简介

- Spring是一个为简化企业级开发而生的**开源框架**。
- Spring是一个**IOC(DI)**和**AOP**容器框架。
- IOC全称：Inversion of Control【控制反转】
  - 将对象【万物皆对象】控制权交个Spring
- DI全称：(Dependency Injection)：依赖注入
- AOP全称：Aspect-Oriented Programming，面向切面编程

- 官网：https://spring.io/

#### 1.2 搭建Spring框架步骤

- 导入jar包

  ```xml
  <!--导入spring-context-->
  <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>5.3.1</version>
  </dependency>
  <!--导入junit4.12-->
  <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
      <scope>test</scope>
  </dependency>
  ```

- 编写核心配置文件

  - 配置文件名称：**applicationContext.xml【beans.xml或spring.xml】**

  - 配置文件路径：**src/main/resources**

  - 示例代码

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    
        <!-- 将对象装配到IOC容器中-->
        <bean id="stuZhenzhong" class="com.atguigu.spring.pojo.Student">
            <property name="stuId" value="101"></property>
            <property name="stuName" value="zhenzhong"></property>
        </bean>
    </beans>
    ```

- 使用核心类库

  ```java
  @Test
  public void testSpring(){
          //使用Spring之前
  //        Student student = new Student();
  
          //使用Spring之后
          //创建容器对象
          ApplicationContext iocObj = 
                  new ClassPathXmlApplicationContext("applicationContext.xml");
          //通过容器对象，获取需要对象
          Student stuZhenzhong = (Student)iocObj.getBean("stuZhenzhong");
          System.out.println("stuZhenzhong = " + stuZhenzhong);
  
      }
  ```

#### 1.3 Spring特性

- 非侵入式：基于Spring开发的应用中的对象可以不依赖于Spring的API。
- 容器：Spring是一个容器，因为它包含并且管理应用对象的生命周期。
- 组件化：Spring实现了使用简单的组件配置组合成一个复杂的应用。在 Spring 中可以使用XML和Java注解组合这些对象。
- 一站式：在IOC和AOP的基础上可以整合各种企业应用的开源框架和优秀的第三方类库（实际上Spring 自身也提供了表述层的SpringMVC和持久层的JDBCTemplate）。

#### 1.4 Spring中getBean()三种方式

- getBean(String beanId)：通过beanId获取对象

  - 不足：需要强制类型转换，不灵活

- getBean(Class clazz)：通过Class方式获取对象

  - 不足：容器中有多个相同类型bean的时候，会报如下错误：

    expected single matching bean but found 2: stuZhenzhong,stuZhouxu

- **getBean(String beanId,Clazz clazz)：通过beanId和Class获取对象**
  - 推荐使用

> 注意：框架默认都是通过无参构造器，帮助我们创建对象。
>
> ​	所以：如提供对象的构造器时，一定添加无参构造器

#### 1.5 bean标签详解

- 属性
  - id：bean的唯一标识
  - class：定义bean的类型【class全类名】
- 子标签
  - property：为对象中属性赋值【set注入】
    - name属性：设置属性名称
    - value属性：设置属性数值