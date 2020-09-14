package com.pg.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.pg.model.TestModel;

@Repository
@Mapper
public interface TestMapper {
	List<TestModel> selectTest();
}
