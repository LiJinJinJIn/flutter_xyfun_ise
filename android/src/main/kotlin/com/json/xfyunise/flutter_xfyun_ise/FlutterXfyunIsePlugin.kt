package com.json.xfyunise.flutter_xfyun_ise

import android.app.Activity
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import com.iflytek.cloud.*
import com.json.xfyunise.flutter_xfyun_ise.ise.result.IseResult
import com.json.xfyunise.flutter_xfyun_ise.ise.result.xml.XmlResultParser
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** xfyun ise Plugin */
class FlutterXfyunIsePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private val TAG = "xxxxxx123"
    private lateinit var mActivity: Activity
    private var mEvaluator: SpeechEvaluator? = null
    private var mLastResult: String? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_xfyun_ise")
        channel.setMethodCallHandler(this)
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> initXFyun(call)

            "setParameter" -> setParameter(call)

            "start" -> start(call)

            "stop" -> stop()

            "cancel" -> cancel()

            "destroy" -> destroy()

            "resultsParsing" -> resultsParsing()
        }
    }

    /**
     * 结果解析
     */
    private fun resultsParsing() {
        if (!TextUtils.isEmpty(mLastResult)) {
            // 解析最终结果
            if (!TextUtils.isEmpty(mLastResult)) {
                val resultParser = XmlResultParser()
                val result: IseResult = resultParser.parse(mLastResult)
                if (result != null) {
                    mActivity.runOnUiThread {
                        channel.invokeMethod("onResultListener", result.total_score.toString())
                    }
                } else {
                    Log.e(TAG, "解析结果为空")
                }
            }
        }
    }

    /**
     * 设置参数
     */
    private fun setParameter(call: MethodCall) {
        Log.e(TAG, "方法：           setParameter")
        if (evaluatorIsNull()) {
            return
        }
        try {
            val map: Map<String, String> =
                (call.argument<Map<String, String>>("param") ?: "") as Map<String, String>
            map.forEach {
                Log.e(TAG, "遍历数据操作：           ${it.key.toString()}   ${it.value.toString()}")
                mEvaluator?.setParameter(it.key, it.value)
            }
        } catch (e: Exception) {
            Log.e(TAG, "e ：         $e")
            e.printStackTrace()
        }
    }

    /**
     * 初始化讯飞
     */
    private fun initXFyun(call: MethodCall) {
        Log.e(TAG, "方法：           initXFyun")
        val appId = call.argument<String>("appid") ?: ""
        SpeechUtility.createUtility(mActivity.application, SpeechConstant.APPID + "=" + appId)
        mEvaluator = SpeechEvaluator.createEvaluator(mActivity.application) { code: Int ->
            if (code != ErrorCode.SUCCESS) {
                Log.e(TAG, "初始化失败：           $code")
            } else {
                Log.e(TAG, "初始化成功")
            }
        }
    }

    /**
     * 判空处理数据
     */
    private fun evaluatorIsNull(): Boolean {
        return mEvaluator == null
    }

    /**
     * 开始测评
     */
    private fun start(call: MethodCall) {
        Log.e(TAG, "方法：           start")
        if (evaluatorIsNull()) {
            Log.e(TAG, "创建失败")
            return
        }
        val content = call.argument<String>("content") ?: ""
        mEvaluator?.startEvaluating(content, null, object : EvaluatorListener {
            override fun onVolumeChanged(volume: Int, data: ByteArray?) {
                Log.e(TAG, "当前音量：$volume")
                Log.e(TAG, "返回音频数据：" + data!!.size)
            }

            override fun onBeginOfSpeech() {
                // 此回调表示：sdk内部录音机已经准备好了，用户可以开始语音输入
                Log.e(TAG, "evaluator begin")
            }

            override fun onEndOfSpeech() {
                // 此回调表示：检测到了语音的尾端点，已经进入识别过程，不再接受语音输入
                Log.e(TAG, "evaluator stoped")
            }

            override fun onResult(result: EvaluatorResult?, isLast: Boolean) {
                Log.e(TAG, "evaluator result :$isLast")
                if (isLast) {
                    val builder = StringBuilder()
                    builder.append(result!!.resultString)
                    mLastResult = builder.toString()
                    Log.e(TAG, "测评结束")
                }
            }

            override fun onError(error: SpeechError?) {
                if (error != null) {
                    Log.e(TAG, "error:" + error.errorCode + "," + error.errorDescription)
                    mActivity.runOnUiThread {
                        channel.invokeMethod(
                            "onErrorListener",
                            error.errorDescription
                        )
                    }
                } else {
                    Log.e(TAG, "evaluator over")
                }
            }

            override fun onEvent(eventType: Int, arg1: Int, arg2: Int, obj: Bundle?) {
                // 以下代码用于获取与云端的会话id，当业务出错时将会话id提供给技术支持人员，可用于查询会话日志，定位出错原因
            }
        })
    }

    /**
     * 停止测评
     */
    private fun stop() {
        Log.e(TAG, "方法：           stop")
        if (evaluatorIsNull()) {
            Log.e(TAG, "创建失败")
            return
        }
        if (mEvaluator!!.isEvaluating) {
            mEvaluator?.stopEvaluating()
        }
    }

    /**
     * 释放测评数据资料
     */
    private fun destroy() {
        Log.e(TAG, "方法：           destroy")
        if (evaluatorIsNull()) {
            Log.e(TAG, "创建失败")
            return
        }
        if (mEvaluator!!.isEvaluating) {
            mEvaluator?.destroy()
        }
    }

    /**
     * 取消测评
     */
    private fun cancel() {
        Log.e(TAG, "方法：           cancel")
        if (evaluatorIsNull()) {
            Log.e(TAG, "创建失败")
            return
        }
        if (mEvaluator!!.isEvaluating) {
            mEvaluator?.cancel()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {

    }
}
