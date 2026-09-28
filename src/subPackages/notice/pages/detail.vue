<template>
  <view class="page">
    <view class="card">
      <uni-tag v-if="top" text="置顶" type="error" size="small" :circle="true" />
      <view class="title">{{ notice.title }}</view>
      <view class="meta">
        <text>🏢 富新社区物业服务中心</text>
        <text class="dot">·</text>
        <text>{{ notice.time }}</text>
      </view>
      <view class="divider"></view>
      <view class="content">
        <text class="para">{{ notice.para1 }}</text>
        <text class="para">{{ notice.para2 }}</text>
      </view>
    </view>

    <view class="card read-card">
      <uni-icons type="eye" size="16" color="#999" />
      <text class="read-text">已有 {{ notice.reads }} 位业主读过此公告</text>
    </view>

    <view class="footer-space"></view>
  </view>
</template>

<script setup lang="ts">
import { ref } from "vue";

const top = ref(true);
const notice = ref({
  title: "关于小区二期地下车库启用的通知",
  time: "2026-08-26 09:30",
  reads: 320,
  para1: "各位业主：\n小区二期地下车库已完成验收，将于 9 月 1 日正式启用。为保障通行秩序，请各位业主注意以下事项：\n1. 车库出入口位于 6 号楼南侧，请按指示牌有序进出；\n2. 请尚未办理车位手续的业主于 8 月 31 日前前往物业服务中心办理；\n3. 车库实行车牌自动识别，未登记车辆无法进入，请及时更新车牌信息。",
  para2: "启用初期物业将安排专人引导，如您在使用过程中遇到任何问题，可拨打物业24小时服务热线 0571-8888 6666，或通过小程序「意见反馈」提交。感谢您的理解与支持！"
});
</script>

<style lang="scss" scoped>
.page {
  min-height: 100vh;
  background: #f5f7f6;
  padding-bottom: 60rpx;
}

.card {
  background: #fff;
  border-radius: 24rpx;
  margin: 24rpx;
  padding: 36rpx;
}

.title {
  font-size: 38rpx;
  font-weight: 700;
  color: #333;
  line-height: 1.5;
  margin-top: 20rpx;
}

.meta {
  display: flex;
  align-items: center;
  font-size: 22rpx;
  color: #b0b0b0;
  margin-top: 20rpx;

  .dot {
    margin: 0 12rpx;
  }
}

.divider {
  height: 1rpx;
  background: #f0f0f0;
  margin: 30rpx 0;
}

.content {
  .para {
    display: block;
    font-size: 28rpx;
    color: #444;
    line-height: 1.8;
    margin-bottom: 24rpx;
    white-space: pre-line;
  }
}

.read-card {
  display: flex;
  align-items: center;
  justify-content: center;

  .read-text {
    font-size: 24rpx;
    color: #999;
    margin-left: 8rpx;
  }
}

.footer-space {
  height: 40rpx;
}
</style>
