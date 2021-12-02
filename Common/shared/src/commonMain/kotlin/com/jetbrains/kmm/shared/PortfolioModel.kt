package com.jetbrains.kmm.shared

import co.touchlab.stately.freeze

class Model() {

    val rootValue: Double by lazy {
        capturedValue
    }

    val capturedValue: Double by lazy {
        0.0
    }

    fun _freeze() {
        freeze()
    }
}
