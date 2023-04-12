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

### day06

### 第二章 SpringIOC底层实现

> IOC：将对象的控制器反转给Spring

#### 2.1 BeanFactory与ApplicationContexet

- BeanFactory：IOC容器的基本实现，是Spring内部的使用接口，是面向Spring本身的，不是提供给开发人员使用的。****
- ApplicationContext：BeanFactory的子接口，提供了更多高级特性。面向Spring的使用者，几乎所有场合都使用ApplicationContext而不是底层的BeanFactory。

#### 2.2 图解IOC类的结构

![image-20220326090009379](03_Spring.assets\image-20220326090009379.png)

- BeanFactory：Spring底层IOC实现【面向Spring框架】
  - ...
    - **ApplicationContext**：面向程序员
      - **ConfigurableApplicationContext：提供关闭或刷新容器对象方法**
        - ...
          - **ClassPathXmlApplicationContext：基于类路径检索xml文件**
          - **AnnotationConfigApplicationContext**：基于注解创建容器对象
          - FileSystemXmlApplicationContext：基于文件系统检索xml文件

### 第三章 Spring依赖注入数值问题【重点】

#### 3.1 字面量数值

- 数据类型：基本数据类型及包装类、String
- 语法：value属性或value标签

#### 3.2 CDATA区

- 语法：\<![CDATA[]]>
- 作用：在xml中定义特殊字符时，使用CDATA区

#### 3.3 外部已声明bean及级联属性赋值

- 语法：ref

- 注意：级联属性更改数值会影响外部声明bean【ref赋值的是引用】

- 示例代码

  ```xml
  <bean id="dept1" class="com.atguigu.pojo.Dept">
      <property name="deptId" value="1"></property>
      <property name="deptName" value="研发部门"></property>
  </bean>
  
  <bean id="empChai" class="com.atguigu.pojo.Employee">
      <property name="id" value="101"></property>
      <property name="lastName" value="chai"></property>
      <property name="email" value="chai@163.com"></property>
      <property name="salary" value="50.5"></property>
      <property name="dept" ref="dept1"></property>
      <property name="dept.deptName" value="财务部门"></property>
  </bean>
  ```

![image-20220326102128821](03_Spring.assets\image-20220326102128821.png)

#### 3.4 内部bean

- 概述

  - 内部类：在一个类中完整定义另一个类，当前类称之为内部类
  - 内部bean：在一个bean中完整定义另一个bean，当前bean称之为内部bean

- 注意：内部bean不会直接装配到IOC容器中

- 示例代码

  ```xml
  <!--    测试内部bean-->
  <bean id="empXin" class="com.atguigu.pojo.Employee">
      <property name="id" value="102"></property>
      <property name="lastName" value="xx"></property>
      <property name="email" value="xx@163.com"></property>
      <property name="salary" value="51.5"></property>
      <property name="dept">
          <bean class="com.atguigu.pojo.Dept">
              <property name="deptId" value="2"></property>
              <property name="deptName" value="人事部门"></property>
          </bean>
      </property>
  </bean>
  ```

#### 3.5 集合

- List

  ```xml
  <!--    测试集合-->
      <bean id="dept3" class="com.atguigu.pojo.Dept">
          <property name="deptId" value="3"></property>
          <property name="deptName" value="程序员鼓励师"></property>
          <property name="empList">
              <list>
                  <ref bean="empChai"></ref>
                  <ref bean="empXin"></ref>
  <!--                <bean></bean>-->
              </list>
          </property>
      </bean>
  
      <!--    测试提取List-->
      <util:list id="empList">
          <ref bean="empChai"></ref>
          <ref bean="empXin"></ref>
      </util:list>
      <bean id="dept4" class="com.atguigu.pojo.Dept">
          <property name="deptId" value="4"></property>
          <property name="deptName" value="运营部门"></property>
          <property name="empList" ref="empList"></property>
      </bean>
  ```

- Map

  ```xml
  <!--    测试Map-->
  <bean id="dept5" class="com.atguigu.pojo.Dept">
      <property name="deptId" value="5"></property>
      <property name="deptName" value="采购部门"></property>
      <property name="empMap">
          <map>
              <entry key="101" value-ref="empChai"></entry>
              <entry>
                  <key><value>103</value></key>
                  <ref bean="empChai"></ref>
              </entry>
              <entry>
                  <key><value>102</value></key>
                  <ref bean="empXin"></ref>
              </entry>
          </map>
      </property>
  </bean>
  
  <util:map id="empMap">
      <entry key="101" value-ref="empChai"></entry>
      <entry>
          <key><value>103</value></key>
          <ref bean="empChai"></ref>
      </entry>
      <entry>
          <key><value>102</value></key>
          <ref bean="empXin"></ref>
      </entry>
  </util:map>
  <bean id="dept6" class="com.atguigu.pojo.Dept">
      <property name="deptId" value="106"></property>
      <property name="deptName" value="后勤部门"></property>
      <property name="empMap" ref="empMap"></property>
  </bean>
  ```



### 第四章 Spring依赖注入方式【基于XML】

> 为属性赋值方式
>
> - 通过xxxset()方法
> - 通过构造器
> - 反射

#### 4.1 set注入

- 语法：\<property>

#### 4.2 构造器注入

- 语法：\<constructor-arg>

#### 4.3 p名称空间注入

> 导入名称空间：xmlns:p="http://www.springframework.org/schema/p"

- 语法：<bean p:xxx>

- 示例代码

  ```xml
  <bean id="stuZhouxu" class="com.atguigu.spring.pojo.Student">
      <property name="stuId" value="102"></property>
      <property name="stuName">
          <value><![CDATA[<<zhouxu>>]]></value>
      </property>
  </bean>
  
  <bean id="stuZhiFeng" class="com.atguigu.spring.pojo.Student">
      <constructor-arg name="stuId" value="103"></constructor-arg>
      <constructor-arg name="stuName" value="zhifeng"></constructor-arg>
  </bean>
  
  <bean id="stuXiaoxi"
        class="com.atguigu.spring.pojo.Student"
        p:stuId="104"
        p:stuName="xiaoxi"></bean>
  ```

### 第五章 Spring管理第三方bean

#### 5.1 Spring管理druid步骤

- 导入jar包

  ```xml
  <!--导入druid的jar包-->
          <dependency>
              <groupId>com.alibaba</groupId>
              <artifactId>druid</artifactId>
              <version>1.1.10</version>
          </dependency>
          <!--导入mysql的jar包-->
          <dependency>
              <groupId>mysql</groupId>
              <artifactId>mysql-connector-java</artifactId>
              <version>5.1.37</version>
  <!--            <version>8.0.26</version>-->
          </dependency>
  ```

- 编写db.properties配置文件

  ```properties
  #key=value
  db.driverClassName=com.mysql.jdbc.Driver
  db.url=jdbc:mysql://localhost:3306/db220106
  db.username=root
  db.password=root
  ```

- 编写applicationContext.xml相关代码

  ```xml
  <!--    加载外部属性文件db.properties-->
  <context:property-placeholder location="classpath:db.properties"></context:property-placeholder>
  
  <!--    装配数据源-->
  <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
      <property name="driverClassName" value="${db.driverClassName}"></property>
      <property name="url" value="${db.url}"></property>
      <property name="username" value="${db.username}"></property>
      <property name="password" value="${db.password}"></property>
  </bean>
  ```

- 测试

  ```java
  @Test
  public void testDruidDataSource() throws Exception{
      //获取容器对象
      ApplicationContext ioc =
              new ClassPathXmlApplicationContext("applicationContext_druid.xml");
  
      DruidDataSource dataSource = ioc.getBean("dataSource", DruidDataSource.class);
      System.out.println("dataSource = " + dataSource);
  
      DruidPooledConnection connection = dataSource.getConnection();
      System.out.println("connection = " + connection);
  
  }
  ```



### 第六章 Spring中FactoryBean

#### 6.1 Spring中两种bean

- 一种是普通bean
- 另一种是工厂bean【FactoryBean】
  - 作用：如需我们程序员参数到bean的创建时，使用FactoryBean

#### 6.2 FactoryBean使用步骤

- 实现FactoryBean接口
- 重写方法【三个】
- 装配工厂bean
- 测试

```java
package com.atguigu.factory;

import com.atguigu.pojo.Dept;
import org.springframework.beans.factory.FactoryBean;

/**
 * @author Chunsheng Zhang 尚硅谷
 * @create 2022/3/26 14:09
 */
public class MyFactoryBean implements FactoryBean<Dept> {

    /**
     * getObject():参数对象创建的方法
     * @return
     * @throws Exception
     */
    @Override
    public Dept getObject() throws Exception {
        Dept dept = new Dept(101,"研发部门");
        //.....
        return dept;
    }

    /**
     * 设置参数对象Class
     * @return
     */
    @Override
    public Class<?> getObjectType() {
        return Dept.class;
    }

    /**
     * 设置当前对象是否为单例
     * @return
     */
    @Override
    public boolean isSingleton() {
        return true;
    }

}
```

### 第七章 Spring中bean的作用域

#### 7.1 语法

- 在bean标签中添加属性：scope属性即可

#### 7.2 四个作用域

- singleton【默认值】：单例【在容器中只有一个对象】
  - 对象创建时机：**创建容器对象时**，创建对象执行
- prototype：多例【在容器中有多个对象】
  - 对象创建时机：**getBean()方法被调用时**，创建对象执行
- request：请求域
  - 当前请求有效，离开请求域失效
  - 当前请求：**URL不变即为当前请求**
- session：会话域
  - 当前会话有效，离开当前会话失效
  - 当前会话：**当前浏览不关闭不更换即为当前会话**

### 第八章 Spring中bean的生命周期

#### 8.1 bean的生命周期

① 通过构造器或工厂方法创建bean实例

② 为bean的属性设置值和对其他bean的引用

③ 调用bean的初始化方法

④  bean可以使用了

⑤ **当容器关闭时**，调用bean的销毁方法

#### 8.2 bean的后置处理器

- 作用：在调用初始化方法前后对bean进行额外的处理。
- 实现：
  - 实现BeanPostProcessor接口
  - 重写方法
    - postProcessBeforeInitialization(Object, String)：在bean的初始化之前执行
    - postProcessAfterInitialization(Object, String)：在bean的初始化之后执行
  - 在容器中装配后置处理器

- 注意：装配后置处理器会为**当前容器中每个bean**均装配，不能为局部bean装配后置处理器

#### 8.3 添加后置处理器后bean的生命周期

① 通过构造器或工厂方法创建bean实例

② 为bean的属性设置值和对其他bean的引用

postProcessBeforeInitialization(Object, String)：在bean的初始化之前执行

③ 调用bean的初始化方法

postProcessAfterInitialization(Object, String)：在bean的初始化之后执行

④  bean可以使用了

⑤ **当容器关闭时**，调用bean的销毁方法



### 第九章 Spring中自动装配【基于XML】

#### 9.1 Spring中提供两种装配方式

- 手动装配
- 自动装配

#### 9.2 Spring自动装配语法及规则

- 在bean标签中添加属性：Autowire即可

  - byName：对象中**属性名称**与容器中的**beanId**进行匹配，如果**属性名与beanId数值一致**，则自动装配成功

  - byType：对象中**属性类型**与容器中**class**进行匹配，**如果唯一匹配则自动装配成功**

    - 匹配0个：未装配

    - 匹配多个，会报错

      **expected single matching bean but found 2: deptDao,deptDao2**

- 注意：基于XML方式的自动装配，只能装配**非字面量**数值

#### 9.3 总结

- 基于xml自动装配，底层使用**set注入**
- 最终：不建议使用byName、byType，**建议使用注解方式自动装配**



### day07

### 第十章 Spring中注解【非常重要】

#### 10.1 使用注解将对象装配到IOC容器中

> 约定：约束>配置【**注解>XML**】>代码
>
> 位置：在类上面标识
>
> 注意：
>
> - Spring本身不区分四个注解【四个注解本质是一样的@Component】，提供四个注解的目的只有一个：提高代码的可读性
> - 只用注解装配对象，默认将类名首字母小写作为beanId
> - 可以使用value属性，设置beanId；当注解中只使用一个value属性时，value关键字可省略

- 装配对象四个注解

  - @Component：装配**普通组件**到IOC容器
  - @Repository：装配**持久化层组件**到IOC容器
  - @Service：装配**业务逻辑层组件**到IOC容器
  - @Controller：装配**控制层|表示层组件**到IOC容器

- 使用注解步骤

  - 导入相关jar包【已导入】

  - 开启组件扫描

    ```xml
    <!--    开启组件扫描
            base-package：设置扫描注解包名【当前包及其子包】
    -->
    <context:component-scan base-package="com.atguigu"></context:component-scan>
    ```

  - 使用注解标识组件

#### 10.2 使用注解装配对象中属性【自动装配】

- **@Autowired注解**

  - 作用：自动装配对象中属性

  - 装配原理：反射机制

  - 装配方式

    - **先按照byType进行匹配**

      - 匹配1个：匹配成功，正常使用

      - 匹配0个：

        - 默认【@Autowired(**required=true**)】报错

          ```java
          /*expected at least 1 bean which qualifies as autowire candidate. 	Dependency annotations: {@org.springframework.beans.factory.annotation.Autowired(required=true)}
          */
          ```

        - @Autowired(**required=false**)，不会报错

      - 匹配多个

        - **再按照byName进行唯一筛选**

          - 筛选成功【对象中属性名称==beanId】，正常使用

          - 筛选失败【对象中属性名称!=beanId】，报如下错误： 

            ```java
            //expected single matching bean but found 2: deptDao,deptDao2
            ```

  - @Autowired中required属性

    - true：表示被标识的属性**必须装配数值**，如未装配，**会报错**。
    - false：表示被标识的属性**不必须装配数值**，如未装配，**不会报错**。

- @Qualifier注解

  - 作用：配合@Autowired一起使用，**将设置beanId名称装配到属性中**
  - 注意：不能单独使用，需要与@Autowired一起使用

- @Value注解

  - 作用：装配对象中属性【字面量数值】

### 第十一章 Spring中组件扫描

#### 11.1 默认使用情况

```xml
<!--    开启组件扫描
        base-package：设置扫描注解包名【当前包及其子包】
-->
<context:component-scan base-package="com.atguigu"></context:component-scan>
```

#### 11.2 包含扫描

- 注意：
  - 使用包含扫描之前，必须设置use-default-filters="false"【关闭当前包及其子包的扫描】
  - type
    - annotation：设置被扫描**注解**的全类名
    - assignable：设置被扫描**实现类**的全类名

```xml
<context:component-scan base-package="com.atguigu" use-default-filters="false">
    <context:include-filter type="annotation" 			 expression="org.springframework.stereotype.Repository"/>
    <context:include-filter type="assignable" expression="com.atguigu.service.impl.DeptServiceImpl"/>
</context:component-scan>
```

#### 11.3 排除扫描

```xml
<!--    【排除扫描】   假设：环境中共有100包，不想扫描2/100-->
    <context:component-scan base-package="com.atguigu">
        <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
<!--        <context:exclude-filter type="assignable" expression="com.atguigu.controller.DeptController"/>-->
    </context:component-scan>
```



### 第十三章 Spring完全注解开发【0配置】

#### 13.1 完全注解开发步骤

1. 创建配置类
2. 在class上面添加注解
   - @Configuration：标识当前类是一个配置类，作用：代替XML配置文件
   - @ComponentScan：设置组件扫描当前包及其子包
3. 使用AnnotationConfigApplicationContext容器对象

#### 13.2 示例代码

```java
/**
 * @author Chunsheng Zhang 尚硅谷
 * @create 2022/3/28 14:05
 */
@Configuration
@ComponentScan(basePackages = "com.atguigu")
public class SpringConfig {
}
```

```java
  @Test
    public void test0Xml(){
        //创建容器对象
//        ApplicationContext context =
//                new ClassPathXmlApplicationContext("applicationContext.xml");
        //使用AnnotationConfigApplicationContext容器对象
        ApplicationContext context =
                new AnnotationConfigApplicationContext(SpringConfig.class);
        DeptDaoImpl deptDao = context.getBean("deptDao", DeptDaoImpl.class);

        System.out.println("deptDao = " + deptDao);
    }
```

### 第十四章 Spring集成Junit4

#### 14.1 集成步骤

1. 导入jar包
   - spring-test-5.3.1.jar
2. 指定Spring的配置文件的路径
   - 【@ContextConfiguration】
3. 指定Spring环境下运行Junit4的运行器
   - @RunWith

#### 14.2 示例代码

```java
/**
 * @author Chunsheng Zhang 尚硅谷
 * @create 2022/3/28 14:12
 */
@ContextConfiguration(locations = "classpath:applicationContext.xml")
@RunWith(SpringJUnit4ClassRunner.class)
public class TestSpringJunit4 {

    @Autowired
    private DeptService deptService;
    
    @Test
    public void testService(){
        //创建容器对象
//        ApplicationContext context =
//                new ClassPathXmlApplicationContext("applicationContext.xml");
//        DeptService deptService = context.getBean("deptService", DeptServiceImpl.class);
        deptService.saveDept(new Dept());
    }
}
```

### 第十五章 AOP前奏

#### 15.1 代理模式

- 代理模式：我们需要做一件事情，又不期望自己亲力亲为，此时，可以找一个代理【中介】

- 我们【目标对象】与中介【代理对象】不能相互转换，因为是“兄弟”关系

  ![image-20220328152852821](03_Spring.assets\image-20220328152852821.png)

#### 15.2 为什么需要代理【程序中】

- 需求：实现【加减乘除】计算器类
  - 在加减乘除方法中，添加日志功能【在计算之前，记录日志。在计算之后，显示结果。】

- 实现后发现问题如下
  - 日志代码**比较分散**，可以提取日志类
  - 日志代码**比较混乱**，日志代码【非核心业务代码】与加减乘除方法【核心业务代码】书写一处

- 总结：在核心业务代码中，**需要添加日志功能，但不期望在核心业务代码中书写日志代码**。
  - 此时：使用代理模式解决问题【**先将日志代码横向提取到日志类中，再动态织入回到业务代码中**】

#### 15.3 手动实现动态代理环境搭建

- 实现方式
  - 基于接口实现动态代理： **JDK动态代理**
  - 基于继承实现动态代理： **Cglib**、Javassist动态代理

- 实现动态代理关键步骤
  - 一个类：**Proxy**
    - 概述：Proxy代理类的基类【类似Object】
    - 作用：newProxyInstance()：创建代理对象
  - 一个接口：InvocationHandler
    - 概述：实现【动态织入效果】关键接口
    - 作用：invoke()，执行invoke()实现动态织入效果

#### 15.4 手动实现动态代理关键步骤

> 注意：代理对象与实现类【目标对象】是“兄弟”关系，不能相互转换

- 创建类【为了实现创建代理对象工具类】
- 提供属性【目标对象：实现类】
- 提供方法【创建代理对象】
- 提供有参构造器【避免目标对为空】

```java
package com.atguigu.beforeaop;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
 * @author Chunsheng Zhang 尚硅谷
 * @create 2022/3/28 16:22
 */
public class MyProxy {

    /**
     * 目标对象【目标客户】
     */
    private Object target;

    public MyProxy(Object target){
        this.target = target;
    }

    /**
     * 获取目标对象的，代理对象
     * @return
     */
    public Object getProxyObject(){
        Object proxyObj = null;

        /**
            类加载器【ClassLoader loader】,目标对象类加载器
            目标对象实现接口：Class<?>[] interfaces,目标对象实现所有接口
            InvocationHandler h
         */
        ClassLoader classLoader = target.getClass().getClassLoader();
        Class<?>[] interfaces = target.getClass().getInterfaces();
        //创建代理对象
        proxyObj = Proxy.newProxyInstance(classLoader, interfaces, new InvocationHandler() {
            //执行invoke()实现动态织入效果
            @Override
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                //获取方法名【目标对象】
                String methodName = method.getName();
                //执行目标方法之前，添加日志
                MyLogging.beforeMethod(methodName,args);
                //触发目标对象目标方法
                Object rs = method.invoke(target, args);
                //执行目标方法之后，添加日志
                MyLogging.afterMethod(methodName,rs);
                return rs;
            }
        });
        return proxyObj;
    }

//    class invocationImpl implements InvocationHandler{
//    }

}
```

```java
@Test
    public void testBeforeAop(){

//        int add = calc.add(1, 2);
//        System.out.println("add = " + add);

        //目标对象
        Calc calc = new CalcImpl();
        //代理工具类
        MyProxy myProxy = new MyProxy(calc);
        //获取代理对象
        Calc calcProxy = (Calc)myProxy.getProxyObject();
        //测试
//        int add = calcProxy.add(1, 2);
        int div = calcProxy.div(2, 1);

    }
```



### day08

### 第十六章 Spring中AOP【重点】

#### 16.1 AspectJ框架【AOP框架】

- AspectJ是Java社区里最完整最流行的AOP框架。
- 在Spring2.0以上版本中，可以使用基于AspectJ注解或基于XML配置的AOP。

#### 16.2 使用AspectJ步骤

1. 添加jar包支持

   ```xml
   <!--        添加AspectJ-->
   <!--spirng-aspects的jar包-->
   <dependency>
       <groupId>org.springframework</groupId>
       <artifactId>spring-aspects</artifactId>
       <version>5.3.1</version>
   </dependency>
   ```

2. 配置文件

   - 开启组件扫描
   - 开启AspectJ注解支持

   ```xml
   <!--    开启组件扫描-->
       <context:component-scan base-package="com.atguigu"></context:component-scan>
   <!--    开启AspectJ注解支持-->
       <aop:aspectj-autoproxy></aop:aspectj-autoproxy>
   ```

3. 将MyLogging类上面添加注解

   - @Component：将当前类标识为一个组件
   - @Aspect：将当前类标识为**切面类**【非核心业务提取类】

4. 将MyLogging中的方法中添加**通知注解**

   - @Before

   ```java
   /**
    * @author Chunsheng Zhang 尚硅谷
    * @create 2022/3/28 16:03
    */
   @Component      //将当前类标识为一个组件
   @Aspect         //将当前类标识为【切面类】【非核心业务提取类】
   public class MyLogging {
       /**
        * 方法之前
        */
       @Before(value = "execution(public int com.atguigu.aop.CalcImpl.add(int, int) )")
       public void beforeMethod(JoinPoint joinPoint){
           //获取方法名称
           String methodName = joinPoint.getSignature().getName();
           //获取参数
           Object[] args = joinPoint.getArgs();
           System.out.println("==>Calc中"+methodName+"方法(),参数："+ Arrays.toString(args));
       }
   }
   ```

5. 测试

   ```java
   @Test
   public void testAop(){
       //创建容器对象
       ApplicationContext context =
               new ClassPathXmlApplicationContext("applicationContext_aop.xml");
   
       Calc calc = context.getBean("calc", Calc.class);
   
        //错误的，代理对象不能转换为目标对象【代理对象与目标对象是兄弟关系】
   	 //CalcImpl calc = context.getBean("calc", CalcImpl.class);
   
       int add = calc.add(1, 2);
   
   }
   ```

#### 16.3 Spring中AOP概述

- AOP：Aspect-Oriented Programming，面向切面编程【面向对象一种补充】
  - 优势：
    - 解决代码**分散问题**
    - 解决代码**混乱问题**
- OOP：Object-Oriented Programming，面向对象编程

#### 16.4 Spring中AOP相关术语

1. 横切关注点：非核心业务代码【日志】，称之为横切关注点
2. **切面(Aspect)**：将横切关注点提取到类中，这个类称之为**切面类**
3. **通知(Advice)**：将横切关注点提取到类中之后，横切关注点更名为：通知
4. 目标(Target)：目标对象，指的是需要被代理的对象【实现类（CalcImpl）】
5. 代理(Proxy)：代理对象可以理解为：中介
6. 连接点(Joinpoint)：通知方法需要指定通知位置，这个位置称之为：连接点【通知之前】
7. **切入点(pointcut)**：通知方法需要指定通知位置，这个位置称之为：切入点【通知之后】

### 第十七章 AspectJ详解【重点】

#### 17.1 AspectJ中切入点表达式

- 语法：@Before(value="execution(权限修饰符   返回值类型   包名.类名.方法名(参数类型))")

- 通配符

  【*】：

  ​			【*】：可以代表任意权限修饰符&返回值类型

  ​			【*】：可以代表任意包名、任意类名、任意方法名

  【..】：

  ​			【..】：代表任意参数类型及参数个数

- 重用切入点表达式

  1. 使用@PointCut注解，提取可重用的切入点表达式

     ```java
     @Pointcut("execution(* com.atguigu.aop.CalcImpl.*(..) )")
     public void myPointCut(){}
     ```

  2. 使用**方法名()**引入切入点表达式

     ```java
     @Before(value = "myPointCut()")
     public void beforeMethod(JoinPoint joinPoint){}
     ```

#### 17.2 AspectJ中JoinPoint对象

- JoinPont【切入点对象】

- 作用：

  - 获取方法名称

    ```java
    //获取方法签名【方法签名=方法名+参数列表】
    joinPoint.getSignature();
    //获取方法名称
    String methodName = joinPoint.getSignature().getName();
    ```

  - 获取参数

    ```java
    Object[] args = joinPoint.getArgs();
    ```

#### 17.3 AspectJ中通知

- 前置通知

  - 语法：@Before

  - 执行时机：指定方法**执行之前**执行【如目标方法中有异常，会执行】

    - 指定方法：切入点表达式设置位置

  - 示例代码

    ```java
    //重用切入点表达式
    @Pointcut("execution(* com.atguigu.aop.CalcImpl.*(..) )")
    public void myPointCut(){}
    @Before(value = "myPointCut()")
    public void beforeMethod(JoinPoint joinPoint){
        //获取方法名称
        String methodName = joinPoint.getSignature().getName();
        //获取参数
        Object[] args = joinPoint.getArgs();
        System.out.println("==>Calc中"+methodName+"方法(),参数："+ Arrays.toString(args));
    }
    ```

- 后置通知

  - 语法：@After

  - 执行时机：指定方法所有通知**执行之后**执行【如目标方法中有异常，会执行】

  - 示例代码

    ```java
    /**
     * 后置通知
     */
    @After("myPointCut()")
    public void afterMethod(JoinPoint joinPoint){
        //获取方法名称
        String methodName = joinPoint.getSignature().getName();
        //获取参数
        Object[] args = joinPoint.getArgs();
        System.out.println("==>Calc中"+methodName+"方法,之后执行!"+Arrays.toString(args));
    }
    ```

- 返回通知

  - 语法：@AfterReturnning

  - 执行时机：指定方法**返回结果时**执行，【如目标方法中有异常，不执行】

  - 注意事项：@AfterReturnning中returning属性与入参中参数名一致

  - 示例代码

    ```java
    /**
     * 返回通知
     */
    @AfterReturning(value = "myPointCut()",returning = "rs")
    public void afterReturnning(JoinPoint joinPoint,Object rs){
        //获取方法名称
        String methodName = joinPoint.getSignature().getName();
        //获取参数
        Object[] args = joinPoint.getArgs();
    
        System.out.println("【返回通知】==>Calc中"+methodName+"方法,返回结果执行!结果："+rs);
    
    }
    ```

- 异常通知

  - 语法：@AfterThrowing

  - 执行时机：指定方法**出现异常时**执行，【如目标方法中**无异常**，不执行】

  - 注意事项：@AfterThrowing中的throwing属性值与入参参数名一致

  - 示例代码：

    ```java
    /**
     * 异常通知
     */
    @AfterThrowing(value = "myPointCut()",throwing = "ex")
    public void afterThrowing(JoinPoint joinPoint,Exception ex){
        //获取方法名称
        String methodName = joinPoint.getSignature().getName();
        //获取参数
        Object[] args = joinPoint.getArgs();
    
        System.out.println("【异常通知】==>Calc中"+methodName+"方法,出现异常时执行!异常："+ex);
    
    }
    ```

  - 总结

    - 有异常：前置通知=》异常通知=》后置通知
    - 无异常：前置通知=》返回通知=》后置通知

- 环绕通知【前四个通知整合】
  - 语法：@Around

  - 作用：整合前四个通知

  - 注意：

    - 参数中必须使用ProceedingJoinPoint
    - 环绕通知必须将返回结果，作为返回值

  - 示例代码

    ```java
    @Around(value = "myPointCut()")
    public Object aroundMethod(ProceedingJoinPoint pjp){
        //获取方法名称
        String methodName = pjp.getSignature().getName();
        //获取参数
        Object[] args = pjp.getArgs();
        //定义返回值
        Object rs = null;
        try {
            //前置通知
            System.out.println("【前置通知】==>Calc中"+methodName+"方法(),参数："+ Arrays.toString(args));
            //触发目标对象的目标方法【加减乘除方法】
            rs = pjp.proceed();
            //返回通知【有异常不执行】
            System.out.println("【返回通知】==>Calc中"+methodName+"方法,返回结果执行!结果："+rs);
        } catch (Throwable throwable) {
            throwable.printStackTrace();
            //异常通知
            System.out.println("【异常通知】==>Calc中"+methodName+"方法,出现异常时执行!异常："+throwable);
        } finally {
            //后置通知【有异常执行】
            System.out.println("【后置通知】==>Calc中"+methodName+"方法,之后执行!"+Arrays.toString(args));
        }
        return rs;
    }
    ```

#### 17.4 定义切面优先级

- 语法：@Order(value=index)

  - index是int类型，默认值是int可存储的最大值
  - 数值越小，优先级越高【一般建议使用正整数】

- 示例代码

  ```java
  @Component
  @Aspect
  @Order(value = 1)
  public class MyValidate {}
  
  @Component      //将当前类标识为一个组件
  @Aspect         //将当前类标识为【切面类】【非核心业务提取类】
  @Order(2)
  public class MyLogging {}
  ```

#### 17.5 基于XML方式配置AOP

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/aop https://www.springframework.org/schema/aop/spring-aop.xsd">

    <!--配置计算器实现类-->
    <bean id="calculator" class="com.atguigu.spring.aop.xml.CalculatorImpl"></bean>

    <!--配置切面类-->
    <bean id="loggingAspect" class="com.atguigu.spring.aop.xml.LoggingAspect"></bean>

    <!--AOP配置-->
    <aop:config>
        <!--配置切入点表达式-->
        <aop:pointcut id="pointCut"
                      expression="execution(* com.atguigu.spring.aop.xml.Calculator.*(..))"/>
        <!--配置切面-->
        <aop:aspect ref="loggingAspect">
            <!--前置通知-->
            <aop:before method="beforeAdvice" pointcut-ref="pointCut"></aop:before>
            <!--返回通知-->
            <aop:after-returning method="returningAdvice" pointcut-ref="pointCut" returning="result"></aop:after-returning>
            <!--异常通知-->
            <aop:after-throwing method="throwingAdvice" pointcut-ref="pointCut" throwing="e"></aop:after-throwing>
            <!--后置通知-->
            <aop:after method="afterAdvice" pointcut-ref="pointCut"></aop:after>
            <!--环绕通知-->
            <aop:around method="aroundAdvice" pointcut-ref="pointCut"></aop:around>
        </aop:aspect>
    </aop:config>
</beans>

```



### 第十八章 Spring中JdbcTemplate

#### 18.1 JdbcTemplate简介

- Spring提供的**JdbcTemplate**是一个小型持久化层框架，简化Jdbc代码。
  - Mybatis是一个半自动化的ORM持久化层框架

#### 18.2 JdbcTemplate基本使用

- 导入jar包

  ```xml
  <!--spring-context-->
  <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>5.3.1</version>
  </dependency>
  <!--spring-jdbc-->
  <!--spring-orm-->
  <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-orm</artifactId>
      <version>5.3.1</version>
  </dependency>
  <!--导入druid的jar包-->
  <dependency>
      <groupId>com.alibaba</groupId>
      <artifactId>druid</artifactId>
      <version>1.1.10</version>
  </dependency>
  <!--导入mysql的jar包-->
  <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>5.1.37</version>
  </dependency>
  <!--junit-->
  <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
      <scope>test</scope>
  </dependency>
  ```
  
- 编写配置文件

  - db.properties：设置连接数据库属性

  - applicationContext.xml【spring配置文件】

    - 加载外部属性文件
    - 装配数据源【DataSources】
    - 装配JdbcTemplate

  - 示例代码

    ```xml
    <!--    加载外部属性文件-->
    <context:property-placeholder location="classpath:db.properties"></context:property-placeholder>
    
    <!--    - 装配数据源【DataSources】-->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="driverClassName" value="${db.driverClassName}"></property>
        <property name="url" value="${db.url}"></property>
        <property name="username" value="${db.username}"></property>
        <property name="password" value="${db.password}"></property>
    </bean>
    
    <!--    - 装配JdbcTemplate-->
    <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
        <property name="dataSource" ref="dataSource"></property>
    </bean>
    ```

- 使用核心类库【JdbcTemplate】

#### 18.3 JdbcTemplate的常用API 

> JdbcTemplate默认：自动提交事务

- jdbcTemplate.**update**(String sql,Object... args)：通用的**增删改**方法
- jdbcTemplate.**batchUpdate**(String sql,List<Object[]> args)：通用**批处理增删改**方法
- jdbcTemplate.**queryForObject**(String sql,Class clazz,Object... args)：查询**单个数值**
  - String sql = "select  count(1)  from tbl_xxx";
- jdbcTemplate.**queryForObject**(String sql,RowMapper<T> rm,Object... args)：查询**单个对象**
  - String sql = "select  col1,col2...  from tbl_xxx";
- jdbcTemplate.**query**(String sql,RowMapper<T> rm,Obejct... args)：查询**多个对象**

#### 18.4 使用JdbcTemplate搭建Service&Dao层

- Service层依赖Dao层

- Dao层依赖JdbcTemplate

- 示例代码

  ```java
  /**
   * @author Chunsheng Zhang 尚硅谷
   * @create 2022/3/29 16:27
   */
  @Repository
  public class DeptDaoImpl implements DeptDao {
  
      @Autowired
      @Qualifier("jdbcTemplate")
      private JdbcTemplate jdbcTemplate;
  
      @Override
      public List<Dept> selectAllDepts() {
  
          String sql = "select dept_id,dept_name from tbl_dept";
          RowMapper<Dept> rowMapper = new BeanPropertyRowMapper<>(Dept.class);
          List<Dept> list = jdbcTemplate.query(sql, rowMapper);
  
          return list;
      }
  }
  
  /**
   * @author Chunsheng Zhang 尚硅谷
   * @create 2022/3/29 16:30
   */
  @Service("deptService")
  public class DeptServiceImpl implements DeptService {
  
      @Autowired
      @Qualifier("deptDaoImpl")
      private DeptDao deptDao;
  
      @Override
      public List<Dept> getAllDepts() {
          return deptDao.selectAllDepts();
      }
  }
  ```

### 第十九章 Spring声明式事务管理

> 回顾事务
>
> 1. 事务四大特征【ACID】
>    - 原子性
>    - 一致性
>    - 隔离性
>    - 持久性
> 2. 事务三种行为
>    - 开启事务：connection.setAutoCommit(false)
>    - 提交事务：connection.commit()
>    - 回滚事务：connection.rollback()

#### 19.1 Spring中支持事务管理

- 编程式事务管理【传统事务管理】

  1) 获取数据库连接Connection对象

  2) 取消事务的自动提交【开启事务】

  3) **执行操作**

  4) 正常完成操作时手动提交事务

  5) 执行失败时回滚事务

  6) 关闭相关资源

  - 不足：
    - 事务管理代码【非核心业务】与核心业务代码相耦合
      - 事务管理代码分散
      - 事务管理代码混乱

- **声明式事务管理【使用AOP管理事务】**

  - 先横向提取【事务管理代码】，再动态织入

#### 19.2 使用声明式事务管理

> 不用事务管理代码，发现：同一个业务中，会出现局部成功及局部失败的现象【不正常】

- 添加支持【AspectJ的jar包】

  ```xml
  <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-aspects</artifactId>
      <version>5.3.1</version>
  </dependency>
  ```

- 编写配置文件

  - **配置事务管理器**
  - **开启事务注解支持**

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns:context="http://www.springframework.org/schema/context"
         xmlns:tx="http://www.springframework.org/schema/tx"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
         http://www.springframework.org/schema/beans/spring-beans.xsd
         http://www.springframework.org/schema/context
         https://www.springframework.org/schema/context/spring-context.xsd
         http://www.springframework.org/schema/tx
         http://www.springframework.org/schema/tx/spring-tx.xsd">	
  <!--  配置事务管理器-->
      <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
          <property name="dataSource" ref="dataSource"></property>
      </bean>
  
  	<!-- 开启事务注解支持
         transaction-manager默认值：transactionManager-->
      <tx:annotation-driven transaction-manager="transactionManager"></tx:annotation-driven>
  </beans>
  ```

- 在需要事务管理的业务方法上，添加注解**@Transactional**

  ```java
  @Transactional
  public void purchase(String username, String isbn) {
      //查询book价格
      Integer price = bookShopDao.findBookPriceByIsbn(isbn);
      //修改库存
      bookShopDao.updateBookStock(isbn);
      //修改余额
      bookShopDao.updateUserAccount(username, price);
  }
  ```

- 总结：
  - 添加声明式事务管理之后，获取是代理对象，代理对象不能转换为目标对象【实现类】

#### 19.3 Spring声明式事务管理属性

> @Transactional注解属性

- **事务传播行为【Propagation】**

  - 当事务方法被另一个事务方法调用时，必须指定事务应该如何传播。

    - 如：执行事务方法method()1【事务x】之后，调用事务方法method2()【事务y】，此时需要设置method()2方法的事务传播行为。

  - Spring的7种传播行为

    | 传播属性         | 描述                                                         |
    | ---------------- | ------------------------------------------------------------ |
    | **REQUIRED**     | 如果有事务在运行，当前的方法就在这个事务内运行；否则就启动一个新的事务，并在自己的事务内运行。 |
    | **REQUIRES_NEW** | 当前的方法***\*必须\****启动新事务，并在自己的事务内运行；如果有事务正在运行，应该将它挂起。 |
    | SUPPORTS         | 如果有事务在运行，当前的方法就在这个事务内运行，否则可以不运行在事务中。 |
    | NOT_SUPPORTED    | 当前的方法不应该运行在事务中，如果有运行的事务将它挂起       |
    | MANDATORY        | 当前的方法必须运行在事务中，如果没有正在运行的事务就抛出异常。 |
    | NEVER            | 当前的方法不应该运行在事务中，如果有正在运行的事务就抛出异常。 |
    | NESTED           | 如果有事务正在运行，当前的方法就应该在这个事务的嵌套事务内运行，否则就启动一个新的事务，并在它自己的事务内运行。 |

  - 图解事务传播行为

    - **REQUIRED**

      ![image-20220330105232095](03_Spring.assets\image-20220330105232095.png)

    - **REQUIRES_NEW**

      ![image-20220330105540637](03_Spring.assets\image-20220330105540637.png)

  - 使用场景

    ```java
    /**
    	1. 去结账时判断余额是否充足，余额不足：一本书都不能卖
    */
    @Transactional(propagation=Propagation.REQUIRED)
    public void purchase(String username, String isbn) {
        //查询book价格
        Integer price = bookShopDao.findBookPriceByIsbn(isbn);
        //修改库存
        bookShopDao.updateBookStock(isbn);
        //修改余额
        bookShopDao.updateUserAccount(username, price);
    }
    
    /**
    	2. 去结账时判断余额是否充足，余额不足：最后导致余额不足的那本书，不让购买
    */
    @Transactional(propagation=Propagation.REQUIRES_NEW)
        public void purchase(String username, String isbn) {
            //查询book价格
            Integer price = bookShopDao.findBookPriceByIsbn(isbn);
            //修改库存
            bookShopDao.updateBookStock(isbn);
            //修改余额
            bookShopDao.updateUserAccount(username, price);
        }
    ```

- 事务隔离级别【Isolation】

- 事务超时

- 事务只读

- 事务回滚【不回滚】











































