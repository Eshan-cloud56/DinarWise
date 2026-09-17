#include <jni.h>
#include <android/log.h>
#include <stdlib.h>
#include <string.h>
#include "whisper.h"
#include "ggml.h"

#define UNUSED(x) (void)(x)
#define TAG "WhisperJNI"

#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, TAG, __VA_ARGS__)
#define LOGW(...) __android_log_print(ANDROID_LOG_WARN, TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, TAG, __VA_ARGS__)

JNIEXPORT jlong JNICALL
Java_com_sl_dinarwise_expensemanager_WhisperLib_initContext(
        JNIEnv *env, jobject thiz, jstring model_path_str) {
    UNUSED(thiz);
    const char *model_path_chars = (*env)->GetStringUTFChars(env, model_path_str, NULL);
    if (!model_path_chars) {
        LOGE("Failed to get model path string");
        return 0;
    }

    struct whisper_context_params cparams = whisper_context_default_params();
    cparams.use_gpu = false;

    struct whisper_context *context = whisper_init_from_file_with_params(model_path_chars, cparams);
    (*env)->ReleaseStringUTFChars(env, model_path_str, model_path_chars);

    if (!context) {
        LOGE("whisper_init_from_file_with_params failed");
        return 0;
    }

    return (jlong) context;
}

JNIEXPORT void JNICALL
Java_com_sl_dinarwise_expensemanager_WhisperLib_freeContext(
        JNIEnv *env, jobject thiz, jlong context_ptr) {
    UNUSED(env);
    UNUSED(thiz);
    if (context_ptr != 0) {
        struct whisper_context *context = (struct whisper_context *) context_ptr;
        whisper_free(context);
    }
}

JNIEXPORT jint JNICALL
Java_com_sl_dinarwise_expensemanager_WhisperLib_fullTranscribe(
        JNIEnv *env, jobject thiz, jlong context_ptr, jint num_threads, jfloatArray audio_data) {
    UNUSED(thiz);
    if (context_ptr == 0) return -1;

    struct whisper_context *context = (struct whisper_context *) context_ptr;
    jfloat *audio_data_arr = (*env)->GetFloatArrayElements(env, audio_data, NULL);
    if (!audio_data_arr) return -2;

    const jsize audio_data_length = (*env)->GetArrayLength(env, audio_data);

    struct whisper_full_params params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY);
    params.print_realtime   = false;
    params.print_progress   = false;
    params.print_timestamps = false;
    params.print_special    = false;
    params.translate        = false;
    params.language         = "auto"; // Multilingual auto-detection
    params.n_threads        = num_threads > 0 ? num_threads : 4;
    params.offset_ms        = 0;
    params.no_context       = true;
    params.single_segment   = false;

    int ret = whisper_full(context, params, audio_data_arr, audio_data_length);
    (*env)->ReleaseFloatArrayElements(env, audio_data, audio_data_arr, JNI_ABORT);

    return (jint) ret;
}

JNIEXPORT jint JNICALL
Java_com_sl_dinarwise_expensemanager_WhisperLib_getTextSegmentCount(
        JNIEnv *env, jobject thiz, jlong context_ptr) {
    UNUSED(env);
    UNUSED(thiz);
    if (context_ptr == 0) return 0;
    struct whisper_context *context = (struct whisper_context *) context_ptr;
    return (jint) whisper_full_n_segments(context);
}

JNIEXPORT jstring JNICALL
Java_com_sl_dinarwise_expensemanager_WhisperLib_getTextSegment(
        JNIEnv *env, jobject thiz, jlong context_ptr, jint index) {
    UNUSED(thiz);
    if (context_ptr == 0) return (*env)->NewStringUTF(env, "");
    struct whisper_context *context = (struct whisper_context *) context_ptr;
    const char *text = whisper_full_get_segment_text(context, index);
    if (!text) return (*env)->NewStringUTF(env, "");
    return (*env)->NewStringUTF(env, text);
}

JNIEXPORT jstring JNICALL
Java_com_sl_dinarwise_expensemanager_WhisperLib_getSystemInfo(
        JNIEnv *env, jobject thiz) {
    UNUSED(thiz);
    return (*env)->NewStringUTF(env, whisper_print_system_info());
}
