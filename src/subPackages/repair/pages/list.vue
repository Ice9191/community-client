<template>
  <view class="page">
    <!-- 状态筛选 -->
    <view class="tabs">
      <view v-for="(t, i) in tabs" :key="t" class="tab-item" :class="{ active: activeTab === i }" @tap="activeTab = i">
        {{ t }}
      </view>
    </view>

    <!-- 报修单列表 -->
    <uni-list :border="false">
      <uni-list-item
        v-for="item in filteredList"
        :key="item.id"
        :clickable="true"
        :show-arrow="true"
        @click="onDetail(item)"
      >
        <template #body>
          <view class="order-card">
            <view class="order-head">
              <text class="order-no">工单号：{{ item.no }}</text>
              <uni-tag :text="item.status" :type="item.tagType" size="small" :circle="true" />
            </view>
            <view class="order-content">{{ item.title }}</view>
            <view class="order-meta">
              <text>🔧 {{ item.category }}</text>
              <text class="dot">·</text>
              <text>{{ item.time }}</text>
            </view>
            <view class="order-foot">
              <text class="order-progress">{{ item.progress }}</text>
            </view>
          </view>
        </template>
      </uni-list-item>
    </uni-list>

    <view class="empty" v-if="filteredList.length === 0">
      <uni-icons type="empty" size="60" color="#cccccc" />
      <text class="empty-text">暂无相关工单</text>
    </view>

    <view class="add-btn" @tap="onAdd">＋ 发起新报修</view>
    <view class="footer-space"></view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";

const tabs = ["全部", "处理中", "已完成", "已评价"];
const activeTab = ref(0);

interface Order {
  id: number;
  no: string;
  title: string;
  category: string;
  time: string;
  status: string;
  tagType: string;
  progress: string;
}

const orders = ref<Order[]>([
  { id: 1, no: "BX20260826001", title: "厨房下水管漏水，水已渗到楼下", category: "管道维修", time: "08-26 14:30", status: "待接单", tagType: "warning", progress: "等待物业接单" },
  { id: 2, no: "BX20260825012", title: "楼道声控灯不亮", category: "公共照明", time: "08-25 09:10", status: "维修中", tagType: "primary", progress: "维修师傅已上门，预计今天完成" },
  { id: 3, no: "BX20260818006", title: "卫生间马桶堵塞", category: "管道维修", time: "08-18 20:40", status: "已完成", tagType: "success", progress: "已完成，请对本次服务进行评价" },
  { id: 4, no: "BX20260810003", title: "入户门锁损坏", category: "门窗维修", time: "08-10 11:20", status: "已完成", tagType: "success", progress: "已评价 ⭐⭐⭐⭐⭐" }
]);

const filteredList = computed(() => {
  if (activeTab.value === 0) return orders.value;
  return orders.value.filter((o) => o.status === tabs[activeTab.value]);
});

function onDetail(item: Order) {
  uni.showToast({ title: `工单 ${item.no}`, icon: "none" });
}
function onAdd() {
  uni.navigateTo({ url: "/pages/repair/add" });
}
</script>

<style lang="scss" scoped>
.page {
  min-height: 100vh;
  background: #f5f7f6;
  padding-bottom: 160rpx;
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

.order-card {
  padding: 24rpx;
  background: #f8faf9;
  border-radius: 20rpx;
  margin: 12rpx 0;

  .order-head {
    display: flex;
    justify-content: space-between;
    align-items: center;

    .order-no {
      font-size: 22rpx;
      color: #b0b0b0;
    }
  }
  .order-content {
    font-size: 30rpx;
    font-weight: 600;
    color: #333;
    margin-top: 16rpx;
  }
  .order-meta {
    font-size: 22rpx;
    color: #999;
    margin-top: 14rpx;

    .dot {
      margin: 0 10rpx;
    }
  }
  .order-foot {
    margin-top: 20rpx;
    padding-top: 20rpx;
    border-top: 1rpx solid #ececec;

    .order-progress {
      font-size: 24rpx;
      color: #666;
    }
  }
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

.add-btn {
  position: fixed;
  left: 30rpx;
  right: 30rpx;
  bottom: 40rpx;
  background: #07c160;
  color: #fff;
  font-size: 30rpx;
  font-weight: 600;
  border-radius: 50rpx;
  height: 92rpx;
  line-height: 92rpx;
  text-align: center;
  box-shadow: 0 10rpx 30rpx rgba(7, 193, 96, 0.35);
}

.footer-space {
  height: 40rpx;
}
</style>
