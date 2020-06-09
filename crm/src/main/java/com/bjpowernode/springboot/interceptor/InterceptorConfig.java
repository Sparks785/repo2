package com.bjpowernode.springboot.interceptor;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class InterceptorConfig implements WebMvcConfigurer {

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		// TODO Auto-generated method stub
		String[] add= {"/**"};
		String[] ex= {"/login.jsp","/image/**","/jquery/**"};
		registry.addInterceptor(new MyInterceptor()).addPathPatterns(add).excludePathPatterns(ex);
	}
	
}
