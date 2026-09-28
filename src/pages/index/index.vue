<template>
	<view class="page">
		<!-- 自定义头部 -->
		<view class="header">
			<view class="header-title">富新社区</view>
			<view class="header-sub">为业主服务 · 共建美好家园</view>
			<uni-search-bar placeholder="搜索公告 / 服务 / 活动" :radius="100" bgColor="#ffffff" cancelButton="none"
				@confirm="onSearch" />
		</view>

		<!-- 轮播图 -->
		<view class="banner-wrap">
			<swiper class="banner" circular autoplay :interval="4000" indicator-dots
				indicator-color="rgba(255,255,255,.4)" indicator-active-color="#ffffff">
				<swiper-item v-for="(item, i) in banners" :key="i" @tap="onBanner(item)">
					<view class="banner-item" :style="{ background: item.bg }">
						<view class="banner-tag">{{ item.tag }}</view>
						<view class="banner-title">{{ item.title }}</view>
						<view class="banner-desc">{{ item.desc }}</view>
					</view>
				</swiper-item>
			</swiper>
		</view>

		<!-- 服务快捷入口 -->
		<view class="grid-card">
			<uni-grid :column="4" :showBorder="false" :square="false" :highlight="false" @change="onGridTap">
				<uni-grid-item v-for="item in menuList" :key="item.id">
					<view class="grid-item">
						<view class="grid-icon" :style="{ background: item.bg }">
							<view v-if="showIcons" :class="['iconfont', 'icon-' + item.icon]"></view>
						</view>
						<text class="grid-name">{{ item.name }}</text>
					</view>
				</uni-grid-item>
			</uni-grid>
		</view>

		<!-- 社区公告 -->
		<view class="notice-card">
			<uni-section title="社区公告" subTitle="查看全部" type="line" @click="goNoticeList" />
			<view v-for="item in notices" :key="item.id" class="notice-item" @tap="goNoticeDetail(item)">
				<view class="notice-title">
					<uni-tag v-if="item.top === 1" text="置顶" type="error" size="small" :circle="true" />
					<text class="notice-text">{{ item.title }}</text>
				</view>
				<view class="notice-meta">
					<text>{{ item.time }}</text>
					<text class="notice-read"><text v-if="showIcons" class="iconfont icon-yuedu"></text>
						{{ item.reads }} 人已读</text>
				</view>
			</view>
		</view>

		<!-- 通知栏 -->
		<view class="tip-bar">
			<van-notice-bar left-icon="volume-o" text="今日天气 26℃ 晴，小区绿化带正在浇灌，请注意避让" color="#07c160"
				background-color="#e8f8ef" />
		</view>

		<view class="footer-space"></view>
	</view>
</template>

<script setup lang="ts">
	import { onLoad, onReady } from "@dcloudio/uni-app";
	import { ref } from "vue";
	import { getMenuListApi, getNoticeListApi } from '@/api/api';
	import type {
		MenuResultType,
		NoticeListType
	} from '@/types/types';

	const showIcons = ref(false)
	const menuList = ref<MenuResultType[]>([])
	const notices = ref<NoticeListType[]>([])

	interface Banner {
		tag : string;
		title : string;
		desc : string;
		emoji : string;
		bg : string;
	}

	const banners = ref<Banner[]>([
		{ tag: "社区活动", title: "全民健身运动会", desc: "本周六上午 9:00 社区广场见", emoji: "🏃", bg: "linear-gradient(135deg,#07C160,#06AD56)" },
		{ tag: "便民通知", title: "燃气安全免费检查", desc: "物业联合燃气公司上门检修", emoji: "🔧", bg: "linear-gradient(135deg,#FF8C42,#FF6B35)" },
		{ tag: "邻里互动", title: "闲置物品交换集市", desc: "把闲置变成惊喜，报名从速", emoji: "🛍️", bg: "linear-gradient(135deg,#4A90D9,#3568C2)" }
	]);

	function onSearch() {
		uni.showToast({ title: "搜索功能开发中", icon: "none" });
	}
	function onBanner(item : Banner) {
		uni.showToast({ title: item.title, icon: "none" });
	}
	function onGridTap(e : any) {
		const item = menuList.value[e.detail.index];
		uni.navigateTo({ url: item.url }).catch(() => {
			uni.switchTab({ url: item.url });
		});
	}
	function goNoticeList() {
		uni.showToast({ title: "公告列表开发中", icon: "none" });
	}
	function goNoticeDetail(item : NoticeListType) {
		uni.navigateTo({ url: `/pages/notice/detail?id=${item.id}` });
	}

	const getList = async () => {
		const [res1, res2] = await Promise.all([getMenuListApi(), getNoticeListApi()])
		menuList.value = res1
		notices.value = res2.list
	}

	onLoad(() => {
		getList()
	})

	onReady(() => {
		uni.loadFontFace({
			family: 'myCustomIcon',
			source: 'url("https://cdn.jsdelivr.net/gh/ice9191/my-icons@main/iconfont.ttf?t=' + Date.now() + '")',
			success: (res) => {
				console.log('图标加载成功', res)
				showIcons.value = true
			},
			fail: (err) => {
				console.log('图标加载失败', err)
			}
		})
	})
</script>

<style lang="scss" scoped>
	.page {
		min-height: 100vh;
		background: #f5f7f6;
		padding-bottom: 20rpx;
	}

	.header {
		background: linear-gradient(135deg, #07c160, #06ad56);
		padding: 30rpx 24rpx 110rpx;
		border-radius: 0 0 40rpx 40rpx;

		.header-title {
			font-size: 40rpx;
			font-weight: 700;
			color: #fff;
		}

		.header-sub {
			font-size: 24rpx;
			color: rgba(255, 255, 255, 0.85);
			margin-top: 6rpx;
			margin-bottom: 20rpx;
		}
	}

	.banner-wrap {
		margin: -80rpx 24rpx 0;

		.banner {
			height: 280rpx;
			border-radius: 24rpx;
			overflow: hidden;

			.banner-item {
				height: 100%;
				border-radius: 24rpx;
				padding: 40rpx;
				box-sizing: border-box;
				position: relative;
				overflow: hidden;

				.banner-tag {
					display: inline-block;
					background: rgba(255, 255, 255, 0.25);
					color: #fff;
					font-size: 22rpx;
					border-radius: 8rpx;
					padding: 4rpx 16rpx;
				}

				.banner-title {
					color: #fff;
					font-size: 40rpx;
					font-weight: 700;
					margin-top: 20rpx;
				}

				.banner-desc {
					color: rgba(255, 255, 255, 0.9);
					font-size: 24rpx;
					margin-top: 10rpx;
				}
			}
		}
	}

	.grid-card {
		background: #fff;
		border-radius: 24rpx;
		margin: 24rpx;
		padding: 20rpx 0 10rpx;

		.grid-item {
			display: flex;
			flex-direction: column;
			align-items: center;
			padding: 14rpx 0;

			.grid-icon {
				width: 88rpx;
				height: 88rpx;
				border-radius: 24rpx;
				display: flex;
				align-items: center;
				justify-content: center;
				font-size: 44rpx;
			}

			.grid-name {
				font-size: 24rpx;
				color: #333;
				margin-top: 12rpx;
			}
		}
	}

	.notice-card {
		background: #fff;
		border-radius: 24rpx;
		margin: 0 24rpx;
		padding: 10rpx 30rpx;

		:deep(.uni-section-header) {
			padding: 24rpx 20rpx 24rpx 0rpx;
		}

		.notice-item {
			padding: 24rpx 0;
			border-bottom: 1rpx solid #f2f2f2;

			&:last-child {
				border-bottom: none;
			}

			.notice-title {
				display: flex;
				align-items: center;

				.notice-text {
					font-size: 28rpx;
					color: #333;
					margin-left: 12rpx;
					flex: 1;
					overflow: hidden;
					text-overflow: ellipsis;
					white-space: nowrap;
				}
			}

			.notice-meta {
				margin-top: 10rpx;
				font-size: 22rpx;
				color: #b0b0b0;
				display: flex;
				justify-content: space-between;
			}
		}
	}

	.tip-bar {
		margin: 24rpx;
		border-radius: 24rpx;
		overflow: hidden;
	}
</style>