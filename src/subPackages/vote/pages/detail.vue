<template>
  <view class="page">
    <!-- 投票标题 -->
    <view class="card head-card">
      <view class="vote-title">{{ vote.title }}</view>
      <view class="vote-meta">
        <text>⏰ {{ vote.deadline }} 截止</text>
        <text class="dot">·</text>
        <text>🗳️ {{ vote.count }} 人已参与</text>
      </view>
      <view class="vote-desc">{{ vote.desc }}</view>
      <uni-tag :text="vote.multi ? '多选投票（最多 2 项）' : '单选投票'" type="primary" size="small" :circle="true" />
    </view>

    <!-- 选项 -->
    <uni-section title="投票选项" type="line" />
    <view class="card">
      <view v-for="(opt, i) in vote.options" :key="i" class="option-item" :class="{ selected: selected.includes(i) }" @tap="onSelect(i)">
        <view class="option-main">
          <view class="option-label">{{ opt.label }}</view>
          <progress class="option-bar" :percent="opt.percent" stroke-width="5" activeColor="#07C160" backgroundColor="#E8ECEA" border-radius="5" />
          <view class="option-nums">{{ opt.count }} 票 · {{ opt.percent }}%</view>
        </view>
        <view class="option-check" :class="{ checked: selected.includes(i) }">
          <uni-icons v-if="selected.includes(i)" type="checkmarkempty" size="14" color="#ffffff" />
        </view>
      </view>
    </view>

    <view class="tip-bar" v-if="voted">✅ 您已参与本次投票，结果将在截止后公布</view>

    <button class="submit-btn" v-if="!voted" @tap="onSubmit">提交投票</button>
    <button class="submit-btn voted-btn" v-else @tap="onBack">返回</button>
    <view class="footer-space"></view>
  </view>
</template>

<script setup lang="ts">
import { ref } from "vue";

interface Option {
  label: string;
  count: number;
  percent: number;
}

const voted = ref(false);
const selected = ref<number[]>([]);

const vote = ref<{
  title: string;
  deadline: string;
  count: number;
  desc: string;
  multi: boolean;
  options: Option[];
}>({
  title: "公共区域增设电动车充电桩选址",
  deadline: "09-10",
  count: 86,
  desc: "为解决小区电动车充电难问题，拟在公共区域增设充电桩，现就选址方案征求业主意见。",
  multi: false,
  options: [
    { label: "点位1：一期花园东侧", count: 21, percent: 24 },
    { label: "点位2：地下车库B区", count: 38, percent: 44 },
    { label: "点位3：小区南门岗亭旁", count: 18, percent: 21 },
    { label: "点位4：不增设，维持现状", count: 9, percent: 11 }
  ]
});

function onSelect(i: number) {
  if (voted.value) return;
  const idx = selected.value.indexOf(i);
  if (idx > -1) {
    selected.value.splice(idx, 1);
  } else {
    if (!vote.value.multi) {
      selected.value = [i];
    } else if (selected.value.length < 2) {
      selected.value.push(i);
    } else {
      uni.showToast({ title: "最多选择 2 项", icon: "none" });
    }
  }
}

function onSubmit() {
  if (selected.value.length === 0) {
    uni.showToast({ title: "请先选择投票项", icon: "none" });
    return;
  }
  voted.value = true;
  uni.showToast({ title: "投票成功", icon: "success" });
}
function onBack() {
  uni.navigateBack();
}
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
  margin: 0 24rpx;
  padding: 30rpx;
}

.head-card {
  .vote-title {
    font-size: 36rpx;
    font-weight: 700;
    color: #333;
    line-height: 1.5;
  }
  .vote-meta {
    display: flex;
    align-items: center;
    font-size: 22rpx;
    color: #999;
    margin-top: 16rpx;

    .dot {
      margin: 0 12rpx;
    }
  }
  .vote-desc {
    font-size: 26rpx;
    color: #666;
    line-height: 1.6;
    margin-top: 20rpx;
    background: #f8faf9;
    border-radius: 12rpx;
    padding: 20rpx;
    margin-bottom: 20rpx;
  }
}

.option-item {
  display: flex;
  align-items: center;
  padding: 24rpx;
  border: 2rpx solid #eee;
  border-radius: 20rpx;
  margin-bottom: 20rpx;

  &:last-child {
    margin-bottom: 0;
  }

  &.selected {
    border-color: #07c160;
    background: #f0fbf4;
  }

  .option-main {
    flex: 1;

    .option-label {
      font-size: 28rpx;
      color: #333;
      font-weight: 500;
    }
    .option-bar {
      margin-top: 16rpx;
    }
    .option-nums {
      font-size: 22rpx;
      color: #999;
      margin-top: 10rpx;
    }
  }
  .option-check {
    width: 44rpx;
    height: 44rpx;
    border-radius: 50%;
    border: 2rpx solid #d9d9d9;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-left: 20rpx;
    flex-shrink: 0;

    &.checked {
      background: #07c160;
      border-color: #07c160;
    }
  }
}

.tip-bar {
  background: #e8f8ef;
  color: #07c160;
  font-size: 26rpx;
  border-radius: 16rpx;
  margin: 24rpx 24rpx 0;
  padding: 24rpx;
}

.submit-btn {
  margin: 40rpx 30rpx 0;
  background: #07c160;
  color: #fff;
  font-size: 32rpx;
  font-weight: 600;
  border-radius: 50rpx;
  height: 92rpx;
  line-height: 92rpx;

  &::after {
    border: none;
  }

  &.voted-btn {
    background: #9aa5a0;
  }
}

.footer-space {
  height: 40rpx;
}
</style>
