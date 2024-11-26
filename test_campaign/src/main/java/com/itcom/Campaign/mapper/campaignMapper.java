package com.itcom.Campaign.mapper;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itcom.Campaign.vo.campaignVo;

@Mapper
public interface campaignMapper {
	
	public List<campaignVo> getAllInfo();
		
	public int insertCampaignAccept(@Param("customerId") String customerId,@Param("imagePath") String imagePath);
	
	public List<campaignVo> getCampaignAccepts();
 


	public void approveCertification1(Map<String, Object> request);

	public void approveCertification(Map<String, Object> params);


}


