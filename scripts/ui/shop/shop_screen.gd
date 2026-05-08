extends Control

@onready var safe_area_margin: MarginContainer = %SafeAreaMargin
@onready var main_column: VBoxContainer = %MainColumn

@onready var title_label: Label = %TitleLabel
@onready var shop_tabs: TabContainer = %ShopTabs

@onready var diamonds_tab: VBoxContainer = %DiamondsTab
@onready var upgrades_tab: VBoxContainer = %UpgradesTab
@onready var rewarded_ad_tab: VBoxContainer = %RewardedAdTab

@onready var diamonds_placeholder_label: Label = %DiamondsPlaceholderLabel
@onready var upgrades_placeholder_label: Label = %UpgradesPlaceholderLabel

@onready var rewarded_ad_description_label: Label = %RewardedAdDescriptionLabel
@onready var rewarded_ad_gold_label: Label = %RewardedAdGoldLabel
@onready var rewarded_ad_reward_label: Label = %RewardedAdRewardLabel
@onready var rewarded_ad_button: Button = %RewardedAdButton

@onready var back_button: Button = %BackButton


func _ready() -> void:
	_apply_texts()
	_connect_buttons()
	_refresh_rewarded_ad_texts()
	_apply_responsive_layout()


func _notification(what: int) -> void:
	if what != NOTIFICATION_RESIZED:
		return

	if not is_node_ready():
		return

	_apply_responsive_layout()


func _apply_texts() -> void:
	title_label.text = TextDatabase.get_text("shop.title")

	diamonds_tab.name = TextDatabase.get_text("shop.tab.diamonds")
	upgrades_tab.name = TextDatabase.get_text("shop.tab.upgrades")
	rewarded_ad_tab.name = TextDatabase.get_text("shop.tab.rewarded_ad")

	diamonds_placeholder_label.text = TextDatabase.get_text("shop.diamonds.placeholder")
	upgrades_placeholder_label.text = TextDatabase.get_text("shop.upgrades.placeholder")

	rewarded_ad_description_label.text = TextDatabase.get_text("shop.rewarded_ad.description")
	rewarded_ad_button.text = TextDatabase.get_text("shop.rewarded_ad.button")
	back_button.text = TextDatabase.get_text("common.back")


func _connect_buttons() -> void:
	rewarded_ad_button.pressed.connect(_on_rewarded_ad_button_pressed)
	back_button.pressed.connect(SceneRouter.go_to_main_menu)


func _refresh_rewarded_ad_texts() -> void:
	rewarded_ad_gold_label.text = TextDatabase.get_text_with_values(
		"shop.rewarded_ad.gold",
		{
			"amount": SaveData.gold
		}
	)

	rewarded_ad_reward_label.text = TextDatabase.get_text_with_values(
		"shop.rewarded_ad.reward",
		{
			"amount": SaveData.get_rewarded_ad_gold_amount()
		}
	)


func _on_rewarded_ad_button_pressed() -> void:
	SaveData.claim_rewarded_ad_reward()
	_refresh_rewarded_ad_texts()


func _apply_responsive_layout() -> void:
	if safe_area_margin == null:
		return

	if main_column == null:
		return

	var viewport_size := get_viewport_rect().size
	var is_portrait := viewport_size.y > viewport_size.x

	if is_portrait:
		_apply_mobile_portrait_layout()
	else:
		_apply_pc_landscape_layout()


func _apply_mobile_portrait_layout() -> void:
	safe_area_margin.add_theme_constant_override("margin_left", 24)
	safe_area_margin.add_theme_constant_override("margin_top", 48)
	safe_area_margin.add_theme_constant_override("margin_right", 24)
	safe_area_margin.add_theme_constant_override("margin_bottom", 48)

	main_column.add_theme_constant_override("separation", 18)

	rewarded_ad_button.custom_minimum_size = Vector2(320, 64)
	back_button.custom_minimum_size = Vector2(320, 60)


func _apply_pc_landscape_layout() -> void:
	safe_area_margin.add_theme_constant_override("margin_left", 96)
	safe_area_margin.add_theme_constant_override("margin_top", 64)
	safe_area_margin.add_theme_constant_override("margin_right", 96)
	safe_area_margin.add_theme_constant_override("margin_bottom", 64)

	main_column.add_theme_constant_override("separation", 16)

	rewarded_ad_button.custom_minimum_size = Vector2(280, 56)
	back_button.custom_minimum_size = Vector2(280, 56)
