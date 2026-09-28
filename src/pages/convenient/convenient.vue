<template>
  <view class="page">
    <!-- 顶部主题区 -->
    <view class="hero">
      <view class="hero-title">便民服务</view>
      <view class="hero-sub">生活所需 · 一触即达</view>
    </view>

    <!-- 便民功能入口 -->
    <view class="func-card">
      <uni-grid :column="4" :showBorder="false" :square="false" :highlight="false" @change="onFuncTap">
        <uni-grid-item v-for="(item, i) in functions" :key="i" :index="i">
          <view class="func-item">
            <view class="func-icon" :style="{ background: item.bg }">{{ item.icon }}</view>
            <text class="func-name">{{ item.name }}</text>
          </view>
        </uni-grid-item>
      </uni-grid>
    </view>

    <!-- 近期活动 -->
    <uni-section title="社区活动" subTitle="更多" type="line" @click="onFunc(1)" />
    <view class="card">
      <view v-for="item in activities" :key="item.id" class="activity-item" @tap="onFunc(1)">
        <view class="activity-date">
          <view class="date-day">{{ item.day }}</view>
          <view class="date-month">{{ item.month }}月</view>
        </view>
        <view class="activity-main">
          <view class="activity-title">{{ item.title }}</view>
          <view class="activity-info">📍 {{ item.place }} · {{ item.time }}</view>
          <view class="activity-info">👥 {{ item.participants }} 人已报名</view>
        </view>
        <uni-tag :text="item.full ? '已满' : '报名'" :type="item.full ? 'default' : 'warning'" size="small" :circle="true" />
      </view>
    </view>

    <!-- 二手闲置 -->
    <uni-section title="二手闲置" subTitle="更多" type="line" @click="onFunc(3)" />
    <view class="card">
      <scroll-view scroll-x class="goods-scroll" :show-scrollbar="false">
        <view class="goods-row">
          <view v-for="item in goods" :key="item.id" class="goods-item" @tap="onFunc(3)">
            <view class="goods-cover" :style="{ background: item.bg }">{{ item.emoji }}</view>
            <view class="goods-name">{{ item.name }}</view>
            <view class="goods-price">¥{{ item.price }}<text class="goods-origin"> ¥{{ item.origin }}</text></view>
          </view>
        </view>
      </scroll-view>
    </view>

    <!-- 快递服务提示 -->
    <view class="card express-card" @tap="onFunc(2)">
      <view class="express-left">
        <text class="express-icon">📦</text>
        <view>
          <view class="express-title">快递代收点</view>
          <view class="express-desc">3 号楼 1 单元架空层 · 08:00-21:00 营业</view>
        </view>
      </view>
      <uni-badge text="1 个待取" type="warning" />
    </view>

    <view class="footer-space"></view>
  </view>
</template>

<script setup lang="ts">
import { ref } from "vue";

interface FuncItem {
  name: string;
  icon: string;
  bg: string;
}

const functions = ref<FuncItem[]>([
  { name: "家政预约", icon: "🧹", bg: "#E8F6FA" },
  { name: "活动报名", icon: "🎉", bg: "#FDEFF2" },
  { name: "快递服务", icon: "📦", bg: "#F3EFE8" },
  { name: "二手闲置", icon: "🔄", bg: "#EAF4EC" }
]);

const activities = ref([
  { id: 1, day: "01", month: "9", title: "全民健身运动会", place: "社区中心广场", time: "周六 09:00-12:00", participants: 128, full: false },
  { id: 2, day: "08", month: "9", title: "亲子烘焙小课堂", place: "邻里中心 2F", time: "周日 14:00-16:00", participants: 42, full: true },
  { id: 3, day: "15", month: "9", title: "老年智能手机培训", place: "党群服务站", time: "周日 09:30-11:00", participants: 65, full: false }
]);

const goods = ref([
  { id: 1, name: "儿童自行车 8成新", price: "120", origin: "300", emoji: "🚲", bg: "#EAF4EC" },
  { id: 2, name: "豆浆机 九阳", price: "60", origin: "299", emoji: "🥛", bg: "#FFF3E8" },
  { id: 3, name: "实木书桌 1.2m", price: "180", origin: "500", emoji: "🪑", bg: "#F3EFE8" },
  { id: 4, name: "小米扫地机器人", price: "450", origin: "1299", emoji: "🤖", bg: "#EDEFFB" }
]);

function onFuncTap(e: any) {
  onFunc(e.detail.index);
}
function onFunc(index: number) {
  uni.showToast({ title: `${functions.value[index].name}功能开发中`, icon: "none" });
}
</script>

<style lang="scss" scoped>
.page {
  min-height: 100vh;
  background: #f5f7f6;
  padding-bottom: 40rpx;
}

.hero {
  background: linear-gradient(135deg, #ff8c42, #ff6b35);
  padding: 40rpx 40rpx 80rpx;
  border-radius: 0 0 40rpx 40rpx;

  .hero-title {
    color: #fff;
    font-size: 40rpx;
    font-weight: 700;
  }
  .hero-sub {
    color: rgba(255, 255, 255, 0.9);
    font-size: 24rpx;
    margin-top: 8rpx;
  }
}

.func-card {
  margin: -40rpx 24rpx 0;
  background: #fff;
  border-radius: 24rpx;
  padding: 20rpx 0 10rpx;

  .func-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 14rpx 0;

    .func-icon {
      width: 88rpx;
      height: 88rpx;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 44rpx;
    }
    .func-name {
      font-size: 24rpx;
      color: #333;
      margin-top: 14rpx;
    }
  }
}

.card {
  background: #fff;
  border-radius: 24rpx;
  margin: 0 24rpx;
  padding: 24rpx;
}

.activity-item {
  display: flex;
  align-items: center;
  padding: 22rpx 0;
  border-bottom: 1rpx solid #f2f2f2;

  &:last-child {
    border-bottom: none;
  }

  .activity-date {
    width: 88rpx;
    height: 88rpx;
    border-radius: 16rpx;
    background: #fff3e8;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    margin-right: 20rpx;
    flex-shrink: 0;

    .date-day {
      font-size: 34rpx;
      font-weight: 700;
      color: #ff6b35;
    }
    .date-month {
      font-size: 20rpx;
      color: #ff8c42;
    }
  }
  .activity-main {
    flex: 1;
    min-width: 0;

    .activity-title {
      font-size: 28rpx;
      color: #333;
      font-weight: 500;
    }
    .activity-info {
      font-size: 22rpx;
      color: #999;
      margin-top: 6rpx;
    }
  }
}

.goods-scroll {
  white-space: nowrap;

  .goods-row {
    display: flex;

    .goods-item {
      width: 220rpx;
      margin-right: 20rpx;
      flex-shrink: 0;

      .goods-cover {
        height: 180rpx;
        border-radius: 16rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 80rpx;
      }
      .goods-name {
        font-size: 24rpx;
        color: #333;
        margin-top: 12rpx;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
      .goods-price {
        font-size: 28rpx;
        color: #ff5b4d;
        font-weight: 600;
        margin-top: 6rpx;

        .goods-origin {
          font-size: 20rpx;
          color: #b0b0b0;
          text-decoration: line-through;
          font-weight: 400;
        }
      }
    }
  }
}

.express-card {
  display: flex;
  align-items: center;
  justify-content: space-between;

  .express-left {
    display: flex;
    align-items: center;

    .express-icon {
      font-size: 56rpx;
      margin-right: 20rpx;
    }
    .express-title {
      font-size: 28rpx;
      font-weight: 600;
      color: #333;
    }
    .express-desc {
      font-size: 22rpx;
      color: #999;
      margin-top: 6rpx;
    }
  }
}

.footer-space {
  height: 40rpx;
}
</style>
