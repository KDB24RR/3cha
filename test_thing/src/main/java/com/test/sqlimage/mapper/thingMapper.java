package com.test.sqlimage.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.test.sqlimage.vo.cartVo;
import com.test.sqlimage.vo.thingVo;

@Mapper
public interface thingMapper {
    
    public List<thingVo> getAllInfo();

    public thingVo getInfo(@Param("thing_id") String thing_id);
    
    public thingVo inputcart(@Param("thing_id") String thing_id);
    
    public cartVo selectcart(@Param("customer_id") String customer_id,
            @Param("thing_id") String thing_id);
    
    public int inputcart(@Param("customer_id") String customer_id,
            @Param("thing_id") String thing_id,
            @Param("num") int num,
            @Param("price") int price,
            @Param("name") String name,
            @Param("image_path") String image_path);
    
    public int updatecart(@Param("customer_id") String customer_id,
    @Param("thing_id") String thing_id,
    @Param("num") int num,
    @Param("price") int price);
    
    public List<cartVo> getcartlist(@Param("customer_id") String customer_id);
    
    public int deletecart(@Param("customer_id") String customer_id,
            @Param("thing_id") String thing_id);

	public void insertThing(thingVo thingVO);

	public cartVo getCartItemByThingId(@Param("thing_id") String thing_id);
	
	public int insertChart(thingVo thingVO);

}
