package com.maadesign.viewstitch

import android.content.Intent
import android.net.Uri
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.maadesign.viewstitch/file_intent"
    private var methodChannel: MethodChannel? = null
    private var pendingFilePath: String? = null

    override fun getInitialRoute(): String? {
        // Prevent FlutterActivity from converting content:// or file:// URI into an initial route
        return "/"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialFile" -> {
                    val path = pendingFilePath ?: handleIntentUri(intent?.data)
                    pendingFilePath = null
                    result.success(path)
                }
                else -> result.notImplemented()
            }
        }

        if (pendingFilePath == null) {
            pendingFilePath = handleIntentUri(intent?.data)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val path = handleIntentUri(intent.data)
        if (path != null) {
            methodChannel?.invokeMethod("onFileOpened", path)
        }
    }

    private fun handleIntentUri(uri: Uri?): String? {
        if (uri == null) return null
        return try {
            val fileName = getFileName(uri) ?: "design_${System.currentTimeMillis()}.dst"
            val outputDir = File(cacheDir, "opened_files")
            if (!outputDir.exists()) {
                outputDir.mkdirs()
            }
            val outputFile = File(outputDir, fileName)

            contentResolver.openInputStream(uri)?.use { inputStream ->
                FileOutputStream(outputFile).use { outputStream ->
                    inputStream.copyTo(outputStream)
                }
            }
            outputFile.absolutePath
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun getFileName(uri: Uri): String? {
        var name: String? = null
        if (uri.scheme == "content") {
            try {
                val cursor = contentResolver.query(uri, null, null, null, null)
                cursor?.use {
                    if (it.moveToFirst()) {
                        val nameIndex = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                        if (nameIndex != -1) {
                            name = it.getString(nameIndex)
                        }
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        if (name == null) {
            name = uri.path
            val cut = name?.lastIndexOf('/') ?: -1
            if (cut != -1) {
                name = name?.substring(cut + 1)
            }
        }
        return name
    }
}
