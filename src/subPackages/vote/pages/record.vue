<template>
  <view class="page">
    <!-- 投票记录列表 -->
    <uni-section title="我的投票记录" type="line" />
    <uni-list :border="false">
      <uni-list-item v-for="item in records" :key="item.id" :clickable="true" :show-arrow="true" @click="onDetail(item)">
        <template #body>
          <view class="vote-card">
            <view class="vote-head">
              <text class="vote-title">{{ item.title }}</text>
              <uni-tag :text="item.status" :type="item.tagType" size="small" :circle="true" />
            </view>
            <view class="vote-choice">我的选择：{{ item.choice }}</view>
            <view class="vote-meta">参与时间 {{ item.time }}</view>
          </view>
        </template>
      </uni-list-item>
    </uni-list>

    <!-- 推荐投票 -->
    <uni-section title="进行中的投票" type="line" />
    <view class="card">
      <view v-for="item in active" :key="item.id" class="active-item" @tap="onDetail(item)">
        <view class="active-title">{{ item.title }}</view>
        <view class="active-meta">{{ item.deadline }}截止 · {{ item.count }} 人参与</view>
      </view>
    </view>

    <view class="footer-space"></view>
  </view>
</template>

<script setup lang="ts">
import { ref } from "vue";

const records = ref([
  { id: 1, title: "小区东门智能门禁改造方案投票", choice: "方案B：人脸识别+刷卡", time: "08-25 10:32", status: "已截止", tagType: "default" },
  { id: 2, title: "二期儿童游乐设施增建投票", choice: "支持增建滑梯组合", time: "08-10 15:20", status: "已截止", tagType: "default" },
  { id: 3, title: "公共区域增设电动车充电桩选址", choice: "点位2：地下车库B区", time: "08-26 09:15", status: "进行中", tagType: "success" }
]);

const active = ref([
  { id: 3, title: "公共区域增设电动车充电桩选址", deadline: "09-10", count: 86 },
  { id: 4, title: "物业费缴纳方式线上化意见征集", deadline: "09-12", count: 53 }
]);

function onDetail(item: any) {
  uni.navigateTo({ url: `/pages/vote/detail?id=${item.id}` });
}
</script>

<style lang="scss" scoped>
.page {
  min-height: 100vh;
  background: #f5f7f6;
  padding-bottom: 40rpx;
}

.vote-card {
  padding: 24rpx;
  background: #f8faf9;
  border-radius: 20rpx;
  margin: 12rpx 0;

  .vote-head {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;

    .vote-title {
      flex: 1;
      font-size: 30rpx;
      font-weight: 600;
      color: #333;
      line-height: 1.4;
      margin-right: 16rpx;
    }
  }
  .vote-choice {
    font-size: 24rpx;
    color: #666;
    background: #fff;
    border-radius: 12rpx;
    padding: 16rpx 20rpx;
    margin-top: 20rpx;
  }
  .vote-meta {
    font-size: 22rpx;
    color: #b0b0b0;
    margin-top: 16rpx;
  }
}

.card {
  background: #fff;
  border-radius: 24rpx;
  margin: 0 24rpx;
  padding: 10rpx 30rpx;

  .active-item {
    padding: 24rpx 0;
    border-bottom: 1rpx solid #f2f2f2;

    &:last-child {
      border-bottom: none;
    }

    .active-title {
      font-size: 28rpx;
      color: #333;
    }
    .active-meta {
      font-size: 22rpx;
      color: #b0b0b0;
      margin-top: 8rpx;
    }
  }
}

.footer-space {
  height: 40rpx;
}
</style>
