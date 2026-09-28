<template>
  <view class="page">
    <!-- 顶部主题区 + 发帖按钮 -->
    <view class="hero">
      <view class="hero-top">
        <view>
          <view class="hero-title">邻里圈子</view>
          <view class="hero-sub">远亲不如近邻</view>
        </view>
        <view class="post-btn" @tap="onPost">✏️ 发帖</view>
      </view>
    </view>

    <!-- 话题标签 -->
    <scroll-view scroll-x class="topic-scroll" :show-scrollbar="false">
      <view class="topic-row">
        <view v-for="(t, i) in topics" :key="t" class="topic-item" :class="{ active: i === activeTopic }" @tap="activeTopic = i">{{ t }}</view>
      </view>
    </scroll-view>

    <!-- 动态列表 -->
    <view class="feed">
      <view v-for="item in feeds" :key="item.id" class="feed-item" @tap="onFeed(item)">
        <view class="feed-head">
          <view class="avatar" :style="{ background: item.avatarBg }">{{ item.nickname[0] }}</view>
          <view class="feed-user">
            <view class="nickname">
              {{ item.nickname }}
              <uni-tag v-if="item.owner" text="业主" type="success" size="small" :circle="true" />
            </view>
            <view class="feed-time">{{ item.time }} · {{ item.floor }}</view>
          </view>
          <view class="feed-more">···</view>
        </view>
        <view class="feed-content">{{ item.content }}</view>
        <view class="feed-images" v-if="item.images">
          <view v-for="(img, i) in item.images" :key="i" class="feed-img" :style="{ background: img }">{{ item.imgEmoji }}</view>
        </view>
        <view class="feed-actions">
          <view class="action-item">👍 {{ item.likes }}</view>
          <view class="action-item">💬 {{ item.comments }}</view>
          <view class="action-item">↗️ 转发</view>
        </view>
      </view>
    </view>

    <view class="footer-space"></view>

    <!-- 发帖悬浮按钮 -->
    <uni-fab :pattern="fabPattern" @fabClick="onPost" />
  </view>
</template>

<script setup lang="ts">
import { ref } from "vue";

const activeTopic = ref(0);
const topics = ref(["全部", "求助互助", "失物招领", "拼车", "二手交换", "社区活动", "闲置赠送"]);

interface Feed {
  id: number;
  nickname: string;
  avatarBg: string;
  owner: boolean;
  time: string;
  floor: string;
  content: string;
  images?: string[];
  imgEmoji: string;
  likes: number;
  comments: number;
}

const feeds = ref<Feed[]>([
  {
    id: 1,
    nickname: "3栋-李阿姨",
    avatarBg: "#FFD9E2",
    owner: true,
    time: "10分钟前",
    floor: "3号楼 2单元",
    content: "谁家有小狗暂时不用的狗笼子？家里来了只流浪狗，想先安置一下，有偿借也可以～",
    images: ["#FFF3E8"],
    imgEmoji: "🐶",
    likes: 12,
    comments: 5
  },
  {
    id: 2,
    nickname: "阳光正好",
    avatarBg: "#D9E8FF",
    owner: true,
    time: "1小时前",
    floor: "5号楼 1单元",
    content: "今早 8 点在一期花园长椅捡到一串钥匙，已交给物业前台，失主可以去认领～",
    images: ["#EDEFFB", "#E8F6FA"],
    imgEmoji: "🔑",
    likes: 35,
    comments: 8
  },
  {
    id: 3,
    nickname: "老王的邻居",
    avatarBg: "#E8F8EF",
    owner: false,
    time: "3小时前",
    floor: "2号楼 3单元",
    content: "周末有没有去市区的小伙伴？可以一起拼车，油费平摊～",
	imgEmoji: "🔑",
    likes: 6,
    comments: 3
  },
  {
    id: 4,
    nickname: "住在河边的猫",
    avatarBg: "#E2E8F0",
    owner: true,
    time: "昨天 20:12",
    floor: "1号楼 2单元",
    content: "楼下的桂花开了，满院子都是香味，拍给大家看看～",
    images: ["#FFF8E1"],
    imgEmoji: "🌸",
    likes: 48,
    comments: 11
  }
]);

const fabPattern = ref({
  color: "#fff",
  backgroundColor: "#3568C2",
  selectedColor: "#3568C2",
  buttonColor: "#3568C2",
  icon: "compose",
  iconColor: "#ffffff"
});

function onPost() {
  uni.showToast({ title: "发帖功能开发中", icon: "none" });
}
function onFeed(item: Feed) {
  uni.showToast({ title: `${item.nickname} 的动态`, icon: "none" });
}
</script>

<style lang="scss" scoped>
.page {
  min-height: 100vh;
  background: #f5f7f6;
  padding-bottom: 40rpx;
}

.hero {
  background: linear-gradient(135deg, #4a90d9, #3568c2);
  padding: 40rpx 30rpx;
  border-radius: 0 0 40rpx 40rpx;

  .hero-top {
    display: flex;
    justify-content: space-between;
    align-items: center;

    .hero-title {
      color: #fff;
      font-size: 40rpx;
      font-weight: 700;
    }
    .hero-sub {
      color: rgba(255, 255, 255, 0.85);
      font-size: 24rpx;
      margin-top: 8rpx;
    }
    .post-btn {
      background: #fff;
      color: #3568c2;
      font-size: 26rpx;
      font-weight: 600;
      border-radius: 40rpx;
      padding: 12rpx 30rpx;
    }
  }
}

.topic-scroll {
  margin-top: 24rpx;
  white-space: nowrap;

  .topic-row {
    display: flex;
    padding: 0 24rpx;

    .topic-item {
      flex-shrink: 0;
      background: #fff;
      color: #666;
      font-size: 24rpx;
      border-radius: 30rpx;
      padding: 10rpx 28rpx;
      margin-right: 16rpx;

      &.active {
        background: #3568c2;
        color: #fff;
      }
    }
  }
}

.feed {
  margin: 24rpx;

  .feed-item {
    background: #fff;
    border-radius: 24rpx;
    padding: 28rpx;
    margin-bottom: 24rpx;

    .feed-head {
      display: flex;
      align-items: center;

      .avatar {
        width: 80rpx;
        height: 80rpx;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 32rpx;
        font-weight: 600;
        color: #666;
        margin-right: 20rpx;
      }
      .feed-user {
        flex: 1;

        .nickname {
          font-size: 28rpx;
          font-weight: 600;
          color: #333;
          display: flex;
          align-items: center;

          uni-tag {
            margin-left: 10rpx;
          }
        }
        .feed-time {
          font-size: 22rpx;
          color: #b0b0b0;
          margin-top: 6rpx;
        }
      }
      .feed-more {
        font-size: 30rpx;
        color: #ccc;
      }
    }
    .feed-content {
      font-size: 28rpx;
      color: #333;
      line-height: 1.6;
      margin-top: 20rpx;
    }
    .feed-images {
      display: flex;
      margin-top: 20rpx;

      .feed-img {
        width: 200rpx;
        height: 200rpx;
        border-radius: 16rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 70rpx;
        margin-right: 16rpx;
      }
    }
    .feed-actions {
      display: flex;
      margin-top: 24rpx;
      padding-top: 20rpx;
      border-top: 1rpx solid #f2f2f2;

      .action-item {
        flex: 1;
        text-align: center;
        font-size: 24rpx;
        color: #999;
      }
    }
  }
}

.footer-space {
  height: 120rpx;
}
</style>
