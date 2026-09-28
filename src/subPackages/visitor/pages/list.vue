<template>
  <view class="page">
    <!-- 状态筛选 -->
    <view class="tabs">
      <view v-for="(t, i) in tabs" :key="t" class="tab-item" :class="{ active: activeTab === i }" @tap="activeTab = i">
        {{ t }}
      </view>
    </view>

    <!-- 预约列表 -->
    <uni-list :border="false">
      <uni-list-item v-for="item in filteredList" :key="item.id" :clickable="true" :show-arrow="true" @click="onDetail(item)">
        <template #body>
          <view class="visit-card">
            <view class="visit-head">
              <view class="visit-user">
                <view class="visit-avatar">{{ item.name[0] }}</view>
                <view>
                  <view class="visit-name">{{ item.name }}<text class="visit-count">（{{ item.count }}人）</text></view>
                  <view class="visit-phone">📞 {{ item.phone }}</view>
                </view>
              </view>
              <uni-tag :text="item.status" :type="item.tagType" size="small" :circle="true" />
            </view>
            <view class="visit-info">
              <view class="info-row">🕐 到访时间：{{ item.time }}</view>
              <view class="info-row" v-if="item.plate">🚗 车牌号码：{{ item.plate }}</view>
              <view class="info-row">📍 通行方式：{{ item.code }}</view>
            </view>
            <view class="visit-foot">
              <text>申请时间 {{ item.applyTime }}</text>
              <view class="visit-actions">
                <text v-if="item.status === '待审核'" class="cancel-btn" @tap.stop="onCancel(item)">撤销</text>
              </view>
            </view>
          </view>
        </template>
      </uni-list-item>
    </uni-list>

    <view class="empty" v-if="filteredList.length === 0">
      <uni-icons type="empty" size="60" color="#cccccc" />
      <text class="empty-text">暂无相关预约记录</text>
    </view>

    <view class="add-btn" @tap="onAdd">＋ 新增访客预约</view>
    <view class="footer-space"></view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";

const tabs = ["全部", "待审核", "已通过", "已过期"];
const activeTab = ref(0);

interface Visit {
  id: number;
  name: string;
  count: number;
  phone: string;
  plate?: string;
  time: string;
  code: string;
  applyTime: string;
  status: string;
  tagType: string;
}

const visits = ref<Visit[]>([
  { id: 1, name: "王建国", count: 2, phone: "138****5678", plate: "浙A·8K321", time: "08-28 10:00 - 12:00", code: "通行码已生成", applyTime: "08-26 09:30", status: "已通过", tagType: "success" },
  { id: 2, name: "李小华", count: 1, phone: "159****2233", time: "08-29 14:00 - 16:00", code: "待生成", applyTime: "08-26 11:05", status: "待审核", tagType: "warning" },
  { id: 3, name: "张阿姨", count: 3, phone: "136****8899", time: "08-20 09:00 - 11:00", code: "通行码已使用", applyTime: "08-19 16:40", status: "已过期", tagType: "default" }
]);

const filteredList = computed(() => {
  if (activeTab.value === 0) return visits.value;
  return visits.value.filter((v) => v.status === tabs[activeTab.value]);
});

function onDetail(item: Visit) {
  uni.showToast({ title: `${item.name} 的预约`, icon: "none" });
}
function onCancel(item: Visit) {
  uni.showModal({
    title: "撤销预约",
    content: `确定撤销 ${item.name} 的访客预约吗？`,
    success: (res) => {
      if (res.confirm) {
        item.status = "已过期";
        item.tagType = "default";
        uni.showToast({ title: "已撤销", icon: "none" });
      }
    }
  });
}
function onAdd() {
  uni.navigateTo({ url: "/pages/visitor/add" });
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
      color: #ff8c42;
      font-weight: 600;

      &::after {
        content: "";
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 40rpx;
        height: 6rpx;
        background: #ff8c42;
        border-radius: 3rpx;
      }
    }
  }
}

.visit-card {
  padding: 24rpx;
  background: #f8faf9;
  border-radius: 20rpx;
  margin: 12rpx 0;

  .visit-head {
    display: flex;
    justify-content: space-between;
    align-items: center;

    .visit-user {
      display: flex;
      align-items: center;

      .visit-avatar {
        width: 76rpx;
        height: 76rpx;
        border-radius: 50%;
        background: #fff3e8;
        color: #ff8c42;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 30rpx;
        font-weight: 600;
        margin-right: 20rpx;
      }
      .visit-name {
        font-size: 30rpx;
        font-weight: 600;
        color: #333;

        .visit-count {
          font-size: 22rpx;
          color: #999;
          font-weight: 400;
        }
      }
      .visit-phone {
        font-size: 22rpx;
        color: #999;
        margin-top: 6rpx;
      }
    }
  }
  .visit-info {
    background: #fff;
    border-radius: 16rpx;
    padding: 20rpx;
    margin-top: 20rpx;

    .info-row {
      font-size: 24rpx;
      color: #666;
      line-height: 1.8;
    }
  }
  .visit-foot {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 20rpx;
    font-size: 22rpx;
    color: #b0b0b0;

    .cancel-btn {
      color: #ff5b4d;
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
  background: #ff8c42;
  color: #fff;
  font-size: 30rpx;
  font-weight: 600;
  border-radius: 50rpx;
  height: 92rpx;
  line-height: 92rpx;
  text-align: center;
  box-shadow: 0 10rpx 30rpx rgba(255, 140, 66, 0.35);
}

.footer-space {
  height: 40rpx;
}
</style>
