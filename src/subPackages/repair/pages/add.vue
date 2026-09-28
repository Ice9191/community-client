<template>
  <view class="page">
    <!-- 报修分类选择 -->
    <uni-section title="选择报修分类" type="line" />
    <view class="category-card">
      <uni-grid :column="3" :showBorder="false" :highlight="false" @change="onCategory">
        <uni-grid-item v-for="(item, i) in categories" :key="i" :index="i">
          <view class="category-item" :class="{ active: form.category === item.name }">
            <view class="category-icon" :style="{ background: item.bg }">{{ item.icon }}</view>
            <text class="category-name">{{ item.name }}</text>
          </view>
        </uni-grid-item>
      </uni-grid>
    </view>

    <!-- 问题描述 -->
    <uni-section title="问题描述" type="line" />
    <view class="form-card">
      <uni-easyinput
        v-model="form.desc"
        type="textarea"
        :maxlength="200"
        placeholder="请详细描述您遇到的问题，如：位置、现象、影响等"
        :auto-height="true"
      />
      <view class="count">{{ form.desc.length }}/200</view>
      <uni-file-picker v-model="images" :limit="3" file-mediatype="image" :auto-upload="false" mode="grid" title="上传现场照片（选填）" />
    </view>

    <!-- 联系信息 -->
    <uni-section title="联系信息" type="line" />
    <uni-list :border="false">
      <uni-list-item title="联系电话">
        <template #body>
          <uni-easyinput v-model="form.phone" type="number" :maxlength="11" placeholder="请输入手机号" />
        </template>
      </uni-list-item>
      <uni-list-item title="预约上门时间">
        <template #body>
          <uni-datetime-picker v-model="form.date" type="date" :border="false" />
        </template>
      </uni-list-item>
    </uni-list>

    <button class="submit-btn" @tap="onSubmit">提交报修</button>
    <view class="tip-text">提交后将由物业统一接单派单，进度可在「我的工单」中查看</view>
  </view>
</template>

<script setup lang="ts">
import { reactive, ref } from "vue";

const categories = ref([
  { name: "管道维修", icon: "🚰", bg: "#E8F8EF" },
  { name: "电力维修", icon: "💡", bg: "#FFF8E1" },
  { name: "门窗维修", icon: "🚪", bg: "#FFF3E8" },
  { name: "公共设施", icon: "🏢", bg: "#EDEFFB" },
  { name: "网络故障", icon: "📡", bg: "#F3EFE8" },
  { name: "其他", icon: "📋", bg: "#E8F6FA" }
]);

const form = reactive({
  category: "管道维修",
  desc: "",
  phone: "138****1234",
  date: ""
});

const images = ref([]);

function onCategory(e: any) {
  form.category = categories.value[e.detail.index].name;
}
function onSubmit() {
  if (!form.desc.trim()) {
    uni.showToast({ title: "请填写问题描述", icon: "none" });
    return;
  }
  uni.showLoading({ title: "提交中..." });
  setTimeout(() => {
    uni.hideLoading();
    uni.showModal({
      title: "提交成功",
      content: "报修工单已提交，物业将尽快处理，请留意消息通知。",
      showCancel: false,
      success: () => uni.navigateBack()
    });
  }, 1000);
}
</script>

<style lang="scss" scoped>
.page {
  min-height: 100vh;
  background: #f5f7f6;
  padding-bottom: 60rpx;
}

.category-card {
  background: #fff;
  border-radius: 24rpx;
  margin: 0 24rpx;
  padding: 20rpx 0 10rpx;

  .category-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 16rpx 0;
    border: 2rpx solid transparent;
    border-radius: 20rpx;

    &.active {
      border-color: #07c160;
      background: #e8f8ef;
    }

    .category-icon {
      width: 80rpx;
      height: 80rpx;
      border-radius: 24rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 40rpx;
    }
    .category-name {
      font-size: 24rpx;
      color: #333;
      margin-top: 12rpx;
    }
  }
}

.form-card {
  background: #fff;
  border-radius: 24rpx;
  margin: 0 24rpx;
  padding: 24rpx;

  .count {
    text-align: right;
    font-size: 22rpx;
    color: #b0b0b0;
    margin-top: 10rpx;
    margin-bottom: 10rpx;
  }
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
}

.tip-text {
  text-align: center;
  font-size: 22rpx;
  color: #b0b0b0;
  margin-top: 20rpx;
}
</style>
