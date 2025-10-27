import { Controller } from "@hotwired/stimulus"
import { Toast } from "bootstrap"

/**
 * トースト通知を制御するStimulusコントローラー
 * - 右上にスライドインするトースト通知を表示
 * - アニメーション完了後にDOMから削除し、背後の要素をクリック可能にする
 */
export default class extends Controller {
  // 定数定義
  static ANIMATION_DURATION = 300 // アニメーション時間（ms）- SCSS の $transition-speed-slow と一致させる
  static HIDE_CLASS = 'hiding'
  static HIDDEN_CLASS = 'hidden'

  connect() {
    // Bootstrapのトーストを初期化
    this.toast = new Toast(this.element)

    // イベントリスナーをバインド（disconnect時にクリーンアップするため）
    this.handleHide = this.onHide.bind(this)
    this.handleHidden = this.onHidden.bind(this)

    // イベントリスナーを設定
    this.element.addEventListener('hide.bs.toast', this.handleHide)
    this.element.addEventListener('hidden.bs.toast', this.handleHidden)

    // トーストを表示
    this.toast.show()
  }

  /**
   * 非表示開始時の処理
   * スライドアウトアニメーションのためのクラスを追加
   */
  onHide() {
    this.element.classList.add(this.constructor.HIDE_CLASS)
  }

  /**
   * 非表示完了時の処理
   * アニメーション完了後にDOMから要素を削除
   */
  onHidden() {
    this.element.classList.add(this.constructor.HIDDEN_CLASS)

    // アニメーション完了を待ってから要素を完全に削除
    setTimeout(() => {
      if (this.toast) {
        this.toast.dispose()
        this.element.remove()
      }
    }, this.constructor.ANIMATION_DURATION)
  }

  /**
   * コントローラーが切断される時のクリーンアップ
   */
  disconnect() {
    // イベントリスナーを削除
    if (this.handleHide) {
      this.element.removeEventListener('hide.bs.toast', this.handleHide)
    }
    if (this.handleHidden) {
      this.element.removeEventListener('hidden.bs.toast', this.handleHidden)
    }

    // Toastインスタンスを破棄
    if (this.toast) {
      this.toast.dispose()
      this.toast = null
    }
  }
}