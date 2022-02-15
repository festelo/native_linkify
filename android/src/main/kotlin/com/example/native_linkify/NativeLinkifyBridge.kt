package com.example.native_linkify

import android.text.SpannableStringBuilder
import android.text.style.URLSpan
import android.text.util.Linkify

interface NativeLinkifyBridge {
    fun findLinks(text: String): List<LinkifyDTO>
}

data class LinkifyDTO(val startIndex: Int, val endIndex: Int, val url: String) {
    fun toMap(): Map<String, Any> {
        return mapOf(
            "startIndex" to startIndex,
            "endIndex" to endIndex,
            "url" to url
        )
    }
}

class AndroidLinkifyBridge : NativeLinkifyBridge {
    override fun findLinks(text: String): List<LinkifyDTO> {
        val spannableStringBuilder = SpannableStringBuilder(text)
        Linkify.addLinks(
            spannableStringBuilder,
            Linkify.EMAIL_ADDRESSES + Linkify.PHONE_NUMBERS + Linkify.WEB_URLS
        )

        val spans = spannableStringBuilder.getSpans(0, text.length, URLSpan::class.java)
        val res = mutableListOf<LinkifyDTO>()
        for (span in spans) {
            res.add(
                LinkifyDTO(
                    spannableStringBuilder.getSpanStart(span),
                    spannableStringBuilder.getSpanEnd(span),
                    span.url
                )
            )
        }
        return res
    }
}
