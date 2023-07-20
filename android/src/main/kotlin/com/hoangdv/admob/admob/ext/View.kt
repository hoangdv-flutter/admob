package com.hoangdv.admob.admob.ext

import android.view.View

var View.isVisible
    get() = visibility == View.VISIBLE
    set(value) {
        visibility = if (value) View.VISIBLE else View.GONE
    }