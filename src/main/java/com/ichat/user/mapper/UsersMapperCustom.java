package com.ichat.user.mapper;

import com.ichat.user.entity.Users;
import com.ichat.friends.entity.vo.FriendRequestVO;
import com.ichat.utils.MyMapper;

import java.util.List;


public interface UsersMapperCustom extends MyMapper<Users> {

    public List<FriendRequestVO> queryFriendRequestList(String acceptUserId);

}