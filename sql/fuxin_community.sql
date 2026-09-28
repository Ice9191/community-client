-- ============================================================
-- 富新社区服务小程序 数据库设计
-- 数据库选型：MySQL 8.0
-- 设计约定：
--   1. 主键统一 id（bigint 自增）
--   2. 逻辑删除 is_deleted（0否 1是），不物理删除
--   3. 通用字段 create_time / update_time
--   4. 字符集 utf8mb4，引擎 InnoDB
-- ============================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `fuxin_community`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `fuxin_community`;

-- ------------------------------------------------------------
-- 1. sys_user 用户表（小程序用户、物业管理员）
-- ------------------------------------------------------------
CREATE TABLE `sys_user` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `openid`      VARCHAR(100) NOT NULL                COMMENT '微信openid，小程序唯一标识',
  `username`    VARCHAR(50)  DEFAULT NULL            COMMENT '用户名（账号密码登录）',
  `password`    VARCHAR(100) DEFAULT NULL            COMMENT '密码（MD5加密）',
  `nickname`    VARCHAR(50)  DEFAULT NULL            COMMENT '微信昵称',
  `avatar`      VARCHAR(255) DEFAULT NULL            COMMENT '头像地址',
  `phone`       VARCHAR(11)  DEFAULT NULL            COMMENT '手机号',
  `user_type`   TINYINT      NOT NULL DEFAULT 1      COMMENT '用户类型：1-普通访客 2-业主 3-物业管理员',
  `status`      TINYINT      NOT NULL DEFAULT 1      COMMENT '状态：0-禁用 1-正常',
  `is_deleted`  TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_openid` (`openid`),
  KEY `idx_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表（小程序用户、物业管理员）';

-- ------------------------------------------------------------
-- 2. community_house 房屋基础表（楼栋单元房号基础库）
-- ------------------------------------------------------------
CREATE TABLE `community_house` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `community_name` VARCHAR(100) DEFAULT NULL            COMMENT '社区名称（富新社区）',
  `building`       VARCHAR(20)  NOT NULL                COMMENT '楼栋号 例：1栋',
  `unit`           VARCHAR(20)  DEFAULT NULL            COMMENT '单元号 例：2单元',
  `room`           VARCHAR(20)  NOT NULL                COMMENT '房号 例：301',
  `status`         TINYINT      NOT NULL DEFAULT 1      COMMENT '0-未启用 1-正常',
  `is_deleted`     TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_community_building_unit_room` (`community_name`, `building`, `unit`, `room`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='房屋信息表（楼栋单元房号基础库）';

-- ------------------------------------------------------------
-- 3. user_house_rel 用户-房屋关联表（核心，多对多）
--    一个业主可绑定多套房，一套房可多个业主
-- ------------------------------------------------------------
CREATE TABLE `user_house_rel` (
  `id`           BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`      BIGINT   NOT NULL                COMMENT '关联sys_user.id',
  `house_id`     BIGINT   NOT NULL                COMMENT '关联community_house.id',
  `audit_status` TINYINT  NOT NULL DEFAULT 0      COMMENT '审核状态：0待审核 1审核通过 2驳回',
  `is_owner`     TINYINT  NOT NULL DEFAULT 0      COMMENT '是否业主 0否1是',
  `is_deleted`   TINYINT  NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_house_id` (`house_id`),
  KEY `idx_user_house` (`user_id`, `house_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户-房屋关联表（业主绑定关系）';

-- ------------------------------------------------------------
-- 4. repair_order 物业报修工单表
-- ------------------------------------------------------------
CREATE TABLE `repair_order` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`        BIGINT       NOT NULL                COMMENT '报修人id（关联sys_user.id）',
  `house_id`       BIGINT       DEFAULT NULL            COMMENT '关联房屋id',
  `repair_type`    VARCHAR(30)  DEFAULT NULL            COMMENT '报修类型：水电/门禁/公共区域/其他',
  `content`        TEXT                                 COMMENT '问题描述',
  `images`         VARCHAR(500) DEFAULT NULL            COMMENT '图片地址，多图逗号分隔',
  `contact_phone`  VARCHAR(11)  DEFAULT NULL            COMMENT '联系电话',
  `expect_time`    DATETIME     DEFAULT NULL            COMMENT '期望上门时间',
  `order_status`   TINYINT      NOT NULL DEFAULT 0      COMMENT '0待接单 1处理中 2已完成 3已取消',
  `handle_user_id` BIGINT       DEFAULT NULL            COMMENT '处理维修人员/物业id',
  `handle_content` TEXT                                 COMMENT '处理备注',
  `finish_images`  VARCHAR(500) DEFAULT NULL            COMMENT '完工照片',
  `score`          TINYINT      DEFAULT NULL            COMMENT '用户评价分数1~5',
  `evaluate`       VARCHAR(255) DEFAULT NULL            COMMENT '用户评价内容',
  `is_deleted`     TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_house_id` (`house_id`),
  KEY `idx_order_status` (`order_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='物业报修工单表';

-- ------------------------------------------------------------
-- 5. visitor_apply 访客预约记录表
-- ------------------------------------------------------------
CREATE TABLE `visitor_apply` (
  `id`              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`         BIGINT       NOT NULL                COMMENT '发起预约的业主id',
  `house_id`        BIGINT       NOT NULL                COMMENT '到访房屋id',
  `visitor_name`    VARCHAR(20)  NOT NULL                COMMENT '访客姓名',
  `visitor_phone`   VARCHAR(11)  NOT NULL                COMMENT '访客手机号',
  `visit_start_time` DATETIME    DEFAULT NULL            COMMENT '到访开始时间',
  `visit_end_time`  DATETIME     DEFAULT NULL            COMMENT '到访结束时间',
  `status`          TINYINT      NOT NULL DEFAULT 0      COMMENT '0待生效 1有效 2已过期 3业主撤销',
  `pass_code`       VARCHAR(50)  DEFAULT NULL            COMMENT '临时通行码（对接门禁使用）',
  `is_deleted`      TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_house_id` (`house_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='访客预约记录表';

-- ------------------------------------------------------------
-- 6. community_notice 社区公告表
-- ------------------------------------------------------------
CREATE TABLE `community_notice` (
  `id`              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title`           VARCHAR(100) NOT NULL                COMMENT '公告标题',
  `content`         TEXT                                 COMMENT '公告正文',
  `cover_img`       VARCHAR(255) DEFAULT NULL            COMMENT '封面图',
  `is_top`          TINYINT      NOT NULL DEFAULT 0      COMMENT '是否置顶 0否1是',
  `publish_status`  TINYINT      NOT NULL DEFAULT 0      COMMENT '0草稿 1已发布',
  `publish_user_id` BIGINT       DEFAULT NULL            COMMENT '发布管理员id',
  `publish_time`    DATETIME     DEFAULT NULL            COMMENT '发布时间',
  `read_count`      INT          NOT NULL DEFAULT 0      COMMENT '阅读数',
  `is_deleted`      TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_publish_status` (`publish_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社区公告表';

-- ------------------------------------------------------------
-- 7. community_vote 投票主表
-- ------------------------------------------------------------
CREATE TABLE `community_vote` (
  `id`              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title`           VARCHAR(100) NOT NULL                COMMENT '投票标题',
  `content`         TEXT                                 COMMENT '投票说明',
  `vote_type`       TINYINT      NOT NULL DEFAULT 1      COMMENT '1单选 2多选',
  `is_anonymous`    TINYINT      NOT NULL DEFAULT 0      COMMENT '是否匿名 0否1是',
  `start_time`      DATETIME     DEFAULT NULL            COMMENT '开始时间',
  `end_time`        DATETIME     DEFAULT NULL            COMMENT '截止时间',
  `status`          TINYINT      NOT NULL DEFAULT 0      COMMENT '0未开始 1进行中 2已结束',
  `publish_user_id` BIGINT       DEFAULT NULL            COMMENT '创建管理员id',
  `is_deleted`      TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='投票主表';

-- ------------------------------------------------------------
-- 8. community_vote_option 投票选项表
-- ------------------------------------------------------------
CREATE TABLE `community_vote_option` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `vote_id`     BIGINT       NOT NULL                COMMENT '关联投票主表id',
  `option_name` VARCHAR(100) NOT NULL                COMMENT '选项名称',
  `count`       INT          NOT NULL DEFAULT 0      COMMENT '该选项投票数量',
  `is_deleted`  TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_vote_id` (`vote_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='投票选项表';

-- ------------------------------------------------------------
-- 9. community_vote_record 用户投票记录表（防止重复投票）
-- ------------------------------------------------------------
CREATE TABLE `community_vote_record` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `vote_id`     BIGINT       NOT NULL                COMMENT '投票id',
  `user_id`     BIGINT       NOT NULL                COMMENT '投票用户id',
  `option_ids`  VARCHAR(100) DEFAULT NULL            COMMENT '选中选项id，多个逗号分隔',
  `is_deleted`  TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_vote_user` (`vote_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户投票记录表';

-- ------------------------------------------------------------
-- 10. neighbor_post 邻里圈子帖子表
-- ------------------------------------------------------------
CREATE TABLE `neighbor_post` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`     BIGINT       NOT NULL                COMMENT '发帖用户id',
  `title`       VARCHAR(100) DEFAULT NULL            COMMENT '标题',
  `content`     TEXT                                 COMMENT '内容',
  `images`      VARCHAR(500) DEFAULT NULL            COMMENT '图片（逗号分隔）',
  `view_count`  INT          NOT NULL DEFAULT 0      COMMENT '浏览量',
  `status`      TINYINT      NOT NULL DEFAULT 0      COMMENT '0待审核 1正常 2下架',
  `is_deleted`  TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='邻里圈子帖子表';

-- ------------------------------------------------------------
-- 11. neighbor_comment 邻里帖子评论表
-- ------------------------------------------------------------
CREATE TABLE `neighbor_comment` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `post_id`     BIGINT       NOT NULL                COMMENT '帖子id（关联neighbor_post.id）',
  `user_id`     BIGINT       NOT NULL                COMMENT '评论人id',
  `content`     VARCHAR(500) NOT NULL                COMMENT '评论内容',
  `is_deleted`  TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_post_id` (`post_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='帖子评论表';

-- ------------------------------------------------------------
-- 12. message_notice 系统消息通知表（工单/预约/公告/审核通知）
-- ------------------------------------------------------------
CREATE TABLE `message_notice` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`     BIGINT       NOT NULL                COMMENT '接收用户id',
  `msg_type`    VARCHAR(30)  NOT NULL                COMMENT '消息类型：工单/预约/公告/审核',
  `title`       VARCHAR(100) DEFAULT NULL            COMMENT '消息标题',
  `content`     VARCHAR(255) DEFAULT NULL            COMMENT '消息内容',
  `relation_id` BIGINT       DEFAULT NULL            COMMENT '关联业务id（工单id/预约id）',
  `is_read`     TINYINT      NOT NULL DEFAULT 0      COMMENT '是否已读 0未读1已读',
  `is_deleted`  TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_is_read` (`is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统消息通知表';

-- ------------------------------------------------------------
-- 13. feedback 用户意见反馈表
-- ------------------------------------------------------------
CREATE TABLE `feedback` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`       BIGINT       NOT NULL                COMMENT '反馈用户id',
  `content`       TEXT                                 COMMENT '反馈内容',
  `images`        VARCHAR(500) DEFAULT NULL            COMMENT '附图（逗号分隔）',
  `status`        TINYINT      NOT NULL DEFAULT 0      COMMENT '0待处理 1已回复',
  `reply_content` VARCHAR(255) DEFAULT NULL            COMMENT '物业回复内容',
  `is_deleted`    TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户意见反馈表';

-- ------------------------------------------------------------
-- 14. menu 首页功能菜单图标库
--     icon 存图标标识（如 banshou 扳手），url 为跳转路径
-- ------------------------------------------------------------
CREATE TABLE `menu` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name`        VARCHAR(50)  NOT NULL                COMMENT '菜单名称',
  `icon`        VARCHAR(50)  NOT NULL                COMMENT '图标标识（iconfont类名后缀），纯小写如 banshou',
  `bg`          VARCHAR(20)  DEFAULT NULL            COMMENT '图标背景色（如 #E8F8EF）',
  `url`         VARCHAR(100) DEFAULT NULL            COMMENT '跳转路径',
  `is_deleted`  TINYINT      NOT NULL DEFAULT 0      COMMENT '逻辑删除 0否1是',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='首页功能菜单图标库';
