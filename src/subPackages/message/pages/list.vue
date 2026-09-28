<template>
  <view class="page">
    <!-- 消息分类 -->
    <view class="tabs">
      <view v-for="(t, i) in tabs" :key="t" class="tab-item" :class="{ active: activeTab === i }" @tap="activeTab = i">
        {{ t }}
      </view>
    </view>

    <!-- 消息列表 -->
    <uni-list :border="false">
      <uni-list-item v-for="item in filteredList" :key="item.id" :clickable="true" :show-arrow="true" @click="onDetail(item)">
        <template #header>
          <view class="msg-icon" :style="{ background: item.bg }">{{ item.icon }}</view>
        </template>
        <template #body>
          <view class="msg-main">
            <view class="msg-top">
              <view class="msg-title">
                {{ item.title }}
                <uni-tag v-if="!item.read" text="未读" type="error" size="small" />
              </view>
            </view>
            <view class="msg-content">{{ item.content }}</view>
          </view>
        </template>
        <template #footer>
          <view class="msg-time">{{ item.time }}</view>
        </template>
      </uni-list-item>
    </uni-list>

    <view class="empty" v-if="filteredList.length === 0">
      <uni-icons type="notification" size="60" color="#cccccc" />
      <text class="empty-text">暂无{{ tabs[activeTab] }}消息</text>
    </view>

    <view class="clear-btn" @tap="onClear">全部已读</view>
    <view class="footer-space"></view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";

const tabs = ["全部", "工单", "系统"];
const activeTab = ref(0);

interface Msg {
  id: number;
  icon: string;
  bg: string;
  title: string;
  time: string;
  content: string;
  read: boolean;
  type: string;
}

const messages = ref<Msg[]>([
  { id: 1, icon: "🔧", bg: "#E8F8EF", title: "报修工单已接单", time: "10:24", content: "您提交的「厨房下水管漏水」工单已由物业接单，维修师傅正在赶往现场。", read: false, type: "工单" },
  { id: 2, icon: "🚪", bg: "#FFF3E8", title: "访客预约审核通过", time: "09:15", content: "王建国的访客预约已通过审核，通行码已生成，点击查看详情。", read: false, type: "工单" },
  { id: 3, icon: "🗳️", bg: "#EDEFFB", title: "投票提醒", time: "昨天", content: "「公共区域增设电动车充电桩选址」投票将于 09-10 截止，请尽快参与。", read: false, type: "系统" },
  { id: 4, icon: "📢", bg: "#E8F6FA", title: "停水通知", time: "昨天", content: "因供水管网检修，08-28 09:00-14:00 全小区暂停供水，请提前储水。", read: true, type: "系统" },
  { id: 5, icon: "⭐", bg: "#FFF8E1", title: "服务评价邀请", time: "08-25", content: "您对工单「楼道声控灯不亮」的服务是否满意？感谢您的反馈。", read: true, type: "工单" }
]);

const filteredList = computed(() => {
  if (activeTab.value === 0) return messages.value;
  return messages.value.filter((m) => m.type === tabs[activeTab.value]);
});

function onDetail(item: Msg) {
  item.read = true;
  uni.showToast({ title: item.title, icon: "none" });
}
function onClear() {
  messages.value.forEach((m) => (m.read = true));
  uni.showToast({ title: "已全部标记为已读", icon: "none" });
}
</script>

<style lang="scss" scoped>
.page {
  min-height: 100vh;
  background: #f5f7f6;
  padding-bottom: 120rpx;
}

.tabs {
  display: flex;
  background: #fff;
  padding: 20rpx 0;

  .tab-item {
    flex: 1;
    text-align: center;
    font-size: 28rpx;
    color: #666;
    position: relative;
    padding-bottom: 14rpx;

    &.active {
      color: #07c160;
      font-weight: 600;

      &::after {
        content: "";
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 40rpx;
        height: 6rpx;
        background: #07c160;
        border-radius: 3rpx;
      }
    }
  }
}

.msg-icon {
  width: 80rpx;
  height: 80rpx;
  border-radius: 20rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40rpx;
  margin-right: 4rpx;
}

.msg-main {
  .msg-title {
    font-size: 28rpx;
    font-weight: 600;
    color: #333;
    display: flex;
    align-items: center;

    uni-tag {
      margin-left: 10rpx;
    }
  }
  .msg-content {
    font-size: 24rpx;
    color: #888;
    line-height: 1.5;
    margin-top: 10rpx;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
    overflow: hidden;
  }
}

.msg-time {
  font-size: 22rpx;
  color: #b0b0b0;
  margin-left: 16rpx;
}

.empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 0;

  .empty-text {
    font-size: 26rpx;
    color: #b0b0b0;
    margin-top: 20rpx;
  }
}

.clear-btn {
  position: fixed;
  left: 30rpx;
  right: 30rpx;
  bottom: 40rpx;
  background: #fff;
  color: #07c160;
  font-size: 30rpx;
  border-radius: 50rpx;
  height: 92rpx;
  line-height: 92rpx;
  text-align: center;
}

.footer-space {
  height: 40rpx;
}
</style>
