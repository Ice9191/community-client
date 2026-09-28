-- ============================================================
-- 富新社区服务小程序 测试种子数据
-- 在导入建表 SQL 之后执行，用于前端页面联调测试
-- ============================================================
USE `fuxin_community`;

-- ------------------------------------------------------------
-- 1. sys_user 用户（2 业主 / 2 访客 / 1 物业 / 1 业主）
-- ------------------------------------------------------------
INSERT INTO `sys_user` (`id`, `openid`, `nickname`, `avatar`, `phone`, `user_type`, `status`) VALUES
(1, 'mock_openid_001', '张三', 'https://example.com/avatar/zhangsan.png', '13800000001', 2, 1),
(2, 'mock_openid_002', '李四', 'https://example.com/avatar/lisi.png',    '13800000002', 2, 1),
(3, 'mock_openid_003', '王五', 'https://example.com/avatar/wangwu.png', '13800000003', 1, 1),
(4, 'mock_openid_004', '赵六', 'https://example.com/avatar/zhaoliu.png', '13800000004', 1, 1),
(5, 'mock_openid_005', '陈主管', 'https://example.com/avatar/admin.png', '13800000005', 3, 1),
(6, 'mock_openid_006', '刘七', 'https://example.com/avatar/liuqi.png',   '13800000006', 2, 1);

-- ------------------------------------------------------------
-- 2. community_house 房屋基础库
-- ------------------------------------------------------------
INSERT INTO `community_house` (`id`, `community_name`, `building`, `unit`, `room`, `status`) VALUES
(1, '富新社区', '1栋', '1单元', '101',  1),
(2, '富新社区', '1栋', '1单元', '102',  1),
(3, '富新社区', '1栋', '2单元', '201',  1),
(4, '富新社区', '2栋', '1单元', '301',  1),
(5, '富新社区', '2栋', '2单元', '502',  1),
(6, '富新社区', '3栋', '1单元', '1101', 1);

-- ------------------------------------------------------------
-- 3. user_house_rel 用户房屋绑定（一户多人 / 一人多房）
-- ------------------------------------------------------------
INSERT INTO `user_house_rel` (`id`, `user_id`, `house_id`, `audit_status`, `is_owner`) VALUES
(1, 1, 1, 1, 1),  -- 张三 绑定 101，业主
(2, 2, 1, 1, 1),  -- 李四 也绑定 101，业主（一户多人）
(3, 1, 3, 1, 1),  -- 张三 再绑定 201（一人多房）
(4, 3, 2, 1, 0),  -- 王五 绑定 102，访客
(5, 6, 4, 1, 1),  -- 刘七 绑定 301，业主
(6, 4, 5, 0, 0);  -- 赵六 申请绑定 502，待审核

-- ------------------------------------------------------------
-- 4. repair_order 报修工单（覆盖各状态）
-- ------------------------------------------------------------
INSERT INTO `repair_order` (`id`, `user_id`, `house_id`, `repair_type`, `content`, `contact_phone`, `expect_time`, `order_status`, `handle_user_id`, `handle_content`, `score`, `evaluate`) VALUES
(1, 1, 1, '水电',   '厨房水龙头漏水，一直在滴水', '13800000001', '2026-08-28 10:00:00', 0, NULL, NULL, NULL, NULL),
(2, 2, 1, '门禁',   '楼下门禁卡刷不开，进不了门', '13800000002', '2026-08-27 15:00:00', 1, 5, '已联系厂家处理门禁主板，预计明天修好', NULL, NULL),
(3, 1, 3, '公共区域', '2单元楼道灯不亮了，晚上看不清', '13800000001', '2026-08-25 09:00:00', 2, 5, '已更换楼道灯泡，恢复正常照明', 5, '处理很快，服务态度好'),
(4, 6, 4, '其他',   '客厅空调外机滴水，需要检查', '13800000006', '2026-08-20 14:00:00', 3, NULL, '用户临时取消', NULL, NULL);

-- ------------------------------------------------------------
-- 5. visitor_apply 访客预约（覆盖各状态）
-- ------------------------------------------------------------
INSERT INTO `visitor_apply` (`id`, `user_id`, `house_id`, `visitor_name`, `visitor_phone`, `visit_start_time`, `visit_end_time`, `status`, `pass_code`) VALUES
(1, 1, 1, '王小明', '13900000001', '2026-08-28 09:00:00', '2026-08-28 18:00:00', 0, 'PASS-2801'),
(2, 1, 1, '李阿姨', '13900000002', '2026-08-27 08:00:00', '2026-08-27 20:00:00', 1, 'PASS-2702'),
(3, 2, 2, '快递员', '13900000003', '2026-08-25 10:00:00', '2026-08-25 11:00:00', 2, 'PASS-2503'),
(4, 6, 4, '张老师', '13900000004', '2026-08-26 14:00:00', '2026-08-26 17:00:00', 3, 'PASS-2604');

-- ------------------------------------------------------------
-- 6. community_notice 社区公告
-- ------------------------------------------------------------
INSERT INTO `community_notice` (`id`, `title`, `content`, `cover_img`, `is_top`, `publish_status`, `publish_user_id`, `publish_time`, `read_count`) VALUES
(1, '关于小区二期地下车库启用的通知', '小区二期地下车库将于9月1日正式启用，请已购买或租赁车位的业主到物业服务中心办理门禁授权，开通期间如有疑问请联系客服。', NULL, 1, 1, 5, '2026-08-26 10:00:00', 320),
(2, '电梯维保计划公示（9月第一周）', '9月1日-9月7日各楼栋电梯例行维保，维保期间电梯将分时段停运，请各位业主合理安排出行时间。', NULL, 0, 1, 5, '2026-08-25 09:30:00', 208),
(3, '中秋业主联谊活动报名开始啦', '中秋将至，物业将于9月15日在社区活动中心举办业主联谊晚会，现场有歌舞表演、抽奖和月饼DIY，名额有限，报名从速！', NULL, 1, 1, 5, '2026-08-24 15:00:00', 156),
(4, '小区喷泉广场地面维修公告', '喷泉广场地面将于8月22日起进行为期一周的维修施工，施工期间请绕行，注意脚下安全。', NULL, 0, 1, 5, '2026-08-22 14:00:00', 98);

-- ------------------------------------------------------------
-- 7. community_vote 投票主表
-- ------------------------------------------------------------
INSERT INTO `community_vote` (`id`, `title`, `content`, `vote_type`, `is_anonymous`, `start_time`, `end_time`, `status`, `publish_user_id`) VALUES
(1, '小区绿化改造方案投票', '小区东侧绿地改造，请选择您更倾向的方案。', 1, 0, '2026-08-20 00:00:00', '2026-08-30 23:59:59', 1, 5),
(2, '社区活动时间投票', '下月社区活动您希望安排在哪个时间段？可多选。', 2, 1, '2026-08-01 00:00:00', '2026-08-15 23:59:59', 2, 5);

-- ------------------------------------------------------------
-- 8. community_vote_option 投票选项
-- ------------------------------------------------------------
INSERT INTO `community_vote_option` (`id`, `vote_id`, `option_name`, `count`) VALUES
(1, 1, '方案A：增加儿童游乐设施', 5),
(2, 1, '方案B：增加健身器材', 3),
(3, 2, '周六上午', 10),
(4, 2, '周六下午', 6),
(5, 2, '周日上午', 4);

-- ------------------------------------------------------------
-- 9. community_vote_record 用户投票记录
-- ------------------------------------------------------------
INSERT INTO `community_vote_record` (`id`, `vote_id`, `user_id`, `option_ids`) VALUES
(1, 1, 1, '1'),
(2, 1, 2, '2'),
(3, 1, 6, '1'),
(4, 2, 3, '3'),
(5, 2, 4, '3,4'),
(6, 2, 1, '4');

-- ------------------------------------------------------------
-- 10. neighbor_post 邻里圈子帖子
-- ------------------------------------------------------------
INSERT INTO `neighbor_post` (`id`, `user_id`, `title`, `content`, `images`, `view_count`, `status`) VALUES
(1, 1, '小区门口捡到一把车钥匙', '今天在1栋楼下捡到一把车钥匙，失主请联系我，电话13800000001。', 'https://example.com/post/keys.png', 12, 1),
(2, 2, '闲置婴儿车低价转让', '家里闲置一台九成新婴儿车，低价转让，有意私聊。', NULL, 35, 1),
(3, 3, '寻物启事：丢失一串手链', '昨天在小区花园丢失一串银色手链，很重要，捡到的邻居麻烦联系我，谢谢！', NULL, 8, 0);

-- ------------------------------------------------------------
-- 11. neighbor_comment 帖子评论
-- ------------------------------------------------------------
INSERT INTO `neighbor_comment` (`id`, `post_id`, `user_id`, `content`) VALUES
(1, 1, 2, '帮你转发到业主群了，希望尽快找到失主'),
(2, 1, 6, '我认识钥匙的主人，已经通知他了'),
(3, 2, 1, '多少钱出？能看看实物图吗'),
(4, 2, 3, '还在吗？我想买');

-- ------------------------------------------------------------
-- 12. message_notice 系统消息（未读/已读）
-- ------------------------------------------------------------
INSERT INTO `message_notice` (`id`, `user_id`, `msg_type`, `title`, `content`, `relation_id`, `is_read`) VALUES
(1, 1, '工单', '报修单已受理', '您的报修单（厨房水龙头漏水）已受理，请耐心等待。', 1, 0),
(2, 1, '审核', '房屋绑定审核通过', '您绑定的房屋 1栋1单元101 已审核通过。', NULL, 1),
(3, 1, '公告', '新公告发布', '《关于小区二期地下车库启用的通知》已发布。', 1, 0),
(4, 2, '工单', '报修处理中', '您的报修单（门禁卡失灵）正在处理中。', 2, 0),
(5, 3, '审核', '房屋绑定审核通过', '您绑定的房屋 1栋1单元102 已审核通过。', NULL, 1);

-- ------------------------------------------------------------
-- 13. feedback 意见反馈（待处理/已回复）
-- ------------------------------------------------------------
INSERT INTO `feedback` (`id`, `user_id`, `content`, `images`, `status`, `reply_content`) VALUES
(1, 3, '电梯里有烟味，卫生情况比较差，希望物业加强清洁。', 'https://example.com/feedback/elevator.png', 0, NULL),
(2, 1, '建议在地下车库增加电动车充电桩，方便业主充电。', NULL, 1, '感谢您的建议，已纳入改造计划，预计下月动工。');

-- ------------------------------------------------------------
-- 14. menu 首页功能菜单（icon 为 iconfont 类名后缀，前端拼 icon-xxx 渲染）
-- ------------------------------------------------------------
INSERT INTO `menu` (`id`, `name`, `icon`, `bg`, `url`) VALUES
(1, '物业报修', 'banshou',  '#E8F8EF', '/pages/repair/add'),
(2, '访客预约', 'fanke',    '#FFF3E8', '/pages/visitor/add'),
(3, '社区投票', 'toupiao',  '#EDEFFB', '/pages/vote/record'),
(4, '意见征集', 'yijian',   '#FFF8E1', '/pages/feedback/add'),
(5, '家政预约', 'jiazheng', '#E8F6FA', '/pages/convenient/convenient'),
(6, '活动报名', 'baoming',  '#FDEFF2', '/pages/convenient/convenient'),
(7, '快递服务', 'kuaidi',   '#F3EFE8', '/pages/convenient/convenient'),
(8, '二手闲置', 'ershou',   '#EAF4EC', '/pages/convenient/convenient');

-- ------------------------------------------------------------
-- 验证：导入后可执行以下查询确认数据
-- SELECT 'sys_user' t, COUNT(*) c FROM sys_user
-- UNION ALL SELECT 'community_house', COUNT(*) FROM community_house
-- UNION ALL SELECT 'user_house_rel', COUNT(*) FROM user_house_rel
-- UNION ALL SELECT 'repair_order', COUNT(*) FROM repair_order
-- UNION ALL SELECT 'visitor_apply', COUNT(*) FROM visitor_apply
-- UNION ALL SELECT 'community_notice', COUNT(*) FROM community_notice
-- UNION ALL SELECT 'community_vote', COUNT(*) FROM community_vote
-- UNION ALL SELECT 'community_vote_option', COUNT(*) FROM community_vote_option
-- UNION ALL SELECT 'community_vote_record', COUNT(*) FROM community_vote_record
-- UNION ALL SELECT 'neighbor_post', COUNT(*) FROM neighbor_post
-- UNION ALL SELECT 'neighbor_comment', COUNT(*) FROM neighbor_comment
-- UNION ALL SELECT 'message_notice', COUNT(*) FROM message_notice
-- UNION ALL SELECT 'feedback', COUNT(*) FROM feedback;
