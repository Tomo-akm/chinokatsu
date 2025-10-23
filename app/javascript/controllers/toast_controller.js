import { Controller } from "@hotwired/stimulus"
import { Toast } from "bootstrap"

// トースト通知を制御するStimulusコントローラー
export default class extends Controller {
  connect() {
    // Bootstrapのトーストを初期化
    const toast = new Toast(this.element, {
      autohide: true,
      delay: 5000 // 5秒後に自動で消える
    })

    // トーストを表示
    toast.show()

    // アニメーション用のクラスを追加
    this.element.classList.add('slide-in')
  }
}