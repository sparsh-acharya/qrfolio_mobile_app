package com.example.qr_folio

import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
	private val shareChannel = "com.example.qr_folio/share"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, shareChannel)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"shareFileAndText" -> {
						val filePath = call.argument<String>("filePath")
						val text = call.argument<String>("text")

						if (filePath.isNullOrBlank()) {
							result.error("invalid_args", "filePath is required", null)
							return@setMethodCallHandler
						}

						val file = File(filePath)
						if (!file.exists()) {
							result.error("file_missing", "File does not exist", null)
							return@setMethodCallHandler
						}

						val uri = FileProvider.getUriForFile(
							this,
							"$packageName.fileprovider",
							file,
						)

						val intent = Intent(Intent.ACTION_SEND).apply {
							type = "*/*"
							putExtra(Intent.EXTRA_STREAM, uri)
							putExtra(Intent.EXTRA_TEXT, text)
							addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
						}

						startActivity(Intent.createChooser(intent, "Share"))
						result.success(true)
					}

					"shareText" -> {
						val text = call.argument<String>("text")

						if (text.isNullOrBlank()) {
							result.error("invalid_args", "text is required", null)
							return@setMethodCallHandler
						}

						val intent = Intent(Intent.ACTION_SEND).apply {
							type = "text/plain"
							putExtra(Intent.EXTRA_TEXT, text)
						}

						startActivity(Intent.createChooser(intent, "Share"))
						result.success(true)
					}

					else -> result.notImplemented()
				}
			}
	}
}
