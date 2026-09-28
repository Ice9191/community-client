<template>
  <view class="page">
    <!-- 账号信息 -->
    <uni-section title="账号信息" type="line" />
    <uni-list :border="false">
      <uni-list-item title="头像" :show-arrow="true" :clickable="true" right-text="更换" @click="onAvatar">
        <template #header>
          <view class="avatar">
            <uni-icons type="person-filled" size="26" color="#07C160" />
          </view>
        </template>
      </uni-list-item>
      <uni-list-item title="昵称" :show-arrow="true" :clickable="true" right-text="小区业主" @click="onAvatar" />
      <uni-list-item title="手机号" :show-arrow="true" :clickable="true" right-text="138****1234" @click="onAvatar" />
      <uni-list-item title="房屋认证" :show-arrow="true" :clickable="true" right-text="已认证" @click="onAvatar" />
    </uni-list>

    <!-- 通知设置 -->
    <uni-section title="通知设置" type="line" />
    <uni-list :border="false">
      <uni-list-item title="消息推送" :show-switch="true" :switch-checked="pushEnabled" @switchChange="pushEnabled = $event.detail.value" />
      <uni-list-item title="公告提醒" :show-switch="true" :switch-checked="noticeEnabled" @switchChange="noticeEnabled = $event.detail.value" />
      <uni-list-item title="免打扰时段" :show-arrow="true" :clickable="true" right-text="22:00 - 07:00" @click="onAvatar" />
    </uni-list>

    <!-- 其他 -->
    <uni-section title="其他" type="line" />
    <uni-list :border="false">
      <uni-list-item title="关于我们" :show-arrow="true" :clickable="true" @click="onAvatar" />
      <uni-list-item title="隐私政策" :show-arrow="true" :clickable="true" @click="onAvatar" />
      <uni-list-item title="清除缓存" :show-arrow="true" :clickable="true" right-text="2.3MB" @click="onAvatar" />
      <uni-list-item title="当前版本" right-text="v1.0.0" />
    </uni-list>

    <view class="logout-btn" @tap="onLogout">退出登录</view>
    <view class="footer-space"></view>
  </view>
</template>

<script setup lang="ts">
import { ref } from "vue";

const pushEnabled = ref(true);
const noticeEnabled = ref(true);

function onAvatar() {
  uni.showToast({ title: "功能开发中", icon: "none" });
}
function onLogout() {
  uni.showModal({
    title: "提示",
    content: "确定要退出登录吗？",
    success: (res) => {
      if (res.confirm) {
        uni.showToast({ title: "已退出登录", icon: "none" });
      }
    }
  });
}
</script>

<style lang="scss" scoped>
.page {
  min-height: 100vh;
  background: #f5f7f6;
  padding-bottom: 60rpx;
}

.avatar {
  width: 64rpx;
  height: 64rpx;
  border-radius: 50%;
  background: #e8f8ef;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 4rpx;
}

.logout-btn {
  margin: 40rpx 24rpx 0;
  background: #fff;
  border-radius: 24rpx;
  text-align: center;
  font-size: 28rpx;
  color: #ff5b4d;
  padding: 26rpx;
}

.footer-space {
  height: 40rpx;
}
</style>
