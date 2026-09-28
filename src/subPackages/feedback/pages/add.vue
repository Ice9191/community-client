<template>
  <view class="page">
    <!-- 反馈类型 -->
    <uni-section title="反馈类型" type="line" />
    <view class="type-card">
      <uni-grid :column="4" :showBorder="false" :square="false" :highlight="false" @change="onType">
        <uni-grid-item v-for="(item, i) in types" :key="i" :index="i">
          <view class="type-item" :class="{ active: form.type === item.name }">
            <view class="type-icon">{{ item.icon }}</view>
            <text class="type-name">{{ item.name }}</text>
          </view>
        </uni-grid-item>
      </uni-grid>
    </view>

    <!-- 反馈内容 -->
    <uni-section title="反馈内容" type="line" />
    <view class="form-card">
      <uni-easyinput
        v-model="form.content"
        type="textarea"
        :maxlength="500"
        placeholder="请描述您的意见或建议，我们会认真对待每一条反馈"
        :auto-height="true"
      />
      <view class="count">{{ form.content.length }}/500</view>
      <uni-file-picker v-model="images" :limit="3" file-mediatype="image" :auto-upload="false" mode="grid" title="上传相关图片（选填）" />
    </view>

    <!-- 联系方式 -->
    <uni-section title="联系方式" type="line" />
    <uni-list :border="false">
      <uni-list-item title="联系电话">
        <template #body>
          <uni-easyinput v-model="form.phone" type="number" :maxlength="11" placeholder="选填，便于我们联系您" />
        </template>
      </uni-list-item>
    </uni-list>

    <button class="submit-btn" @tap="onSubmit">提交反馈</button>
    <view class="tip-text">提交成功后可获得积分奖励，感谢您为社区建设出力</view>
  </view>
</template>

<script setup lang="ts">
import { reactive, ref } from "vue";

const types = ref([
  { name: "建议", icon: "💡" },
  { name: "投诉", icon: "📢" },
  { name: "表扬", icon: "👍" },
  { name: "其他", icon: "📋" }
]);

const form = reactive({
  type: "建议",
  content: "",
  phone: ""
});

const images = ref([]);

function onType(e: any) {
  form.type = types.value[e.detail.index].name;
}
function onSubmit() {
  if (!form.content.trim()) {
    uni.showToast({ title: "请填写反馈内容", icon: "none" });
    return;
  }
  uni.showLoading({ title: "提交中..." });
  setTimeout(() => {
    uni.hideLoading();
    uni.showModal({
      title: "提交成功",
      content: "您的反馈已收到，我们将尽快处理并给予答复。",
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

.type-card {
  background: #fff;
  border-radius: 24rpx;
  margin: 0 24rpx;
  padding: 20rpx 0 10rpx;

  .type-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 14rpx 0;
    border: 2rpx solid transparent;
    border-radius: 20rpx;

    &.active {
      border-color: #07c160;
      background: #e8f8ef;
    }

    .type-icon {
      font-size: 44rpx;
    }
    .type-name {
      font-size: 24rpx;
      color: #333;
      margin-top: 10rpx;
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
