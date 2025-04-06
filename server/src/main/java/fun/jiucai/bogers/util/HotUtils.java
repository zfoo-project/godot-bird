/*
 * Copyright (C) 2020 The zfoo Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and limitations under the License.
 */

package fun.jiucai.bogers.util;

import com.zfoo.hotswap.util.HotSwapUtils;
import com.zfoo.net.NetContext;
import com.zfoo.protocol.collection.ArrayUtils;
import com.zfoo.protocol.util.FileUtils;
import com.zfoo.protocol.util.StringUtils;
import com.zfoo.storage.StorageContext;
import com.zfoo.storage.manager.AbstractStorage;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayInputStream;
import java.util.Map;
import java.util.function.BiConsumer;
import java.util.stream.Collectors;

/**
 * @author yidingzhao
 * @version 1.0
 * @since 2021-02-05 13:42
 */
@Slf4j
public abstract class HotUtils {

    public static final String EXCEL_HOTSWAP_ZK_PATH = "/excelHotswap";

    public static final String JAVA_HOTSWAP_ZK_PATH = "/javaHotswap";

    public static Map<String, Class<?>> configSimpleClazzNameMap() {
        Map<String, Class<?>> clazzSimpleNameMap = StorageContext.getStorageManager()
                .storageMap()
                .keySet()
                .stream()
                .collect(Collectors.toMap(key -> key.getSimpleName(), value -> value));
        return clazzSimpleNameMap;
    }

    /**
     * 分布式热更新配置表
     */
    public static void startHotSwapConfig() {
        log.info("开启Excel配置表热更新");
        NetContext.getConfigManager().getRegistry().addListener(EXCEL_HOTSWAP_ZK_PATH, new BiConsumer<String, byte[]>() {
            @Override
            public void accept(String path, byte[] bytes) {
                if (path.equals(EXCEL_HOTSWAP_ZK_PATH)) {
                    return;
                }

                if (ArrayUtils.isEmpty(bytes)) {
                    log.info("zk收到path[{}]更新length[{}]", path, 0);
                    return;
                }

                log.info("zk收到path[{}]更新length[{}]", path, bytes.length);

                var fileName = StringUtils.substringAfterLast(path, StringUtils.SLASH);
                var fileSimpleName = FileUtils.fileSimpleName(fileName);
                var fileExtName = FileUtils.fileExtName(fileName);

                var clazzSimpleNameMap = HotUtils.configSimpleClazzNameMap();
                var clazz = clazzSimpleNameMap.get(fileSimpleName);

                // 如果该excel在当前项目中没有被使用，则不必解析配置表，也不用去更新了
                var currentStorage = StorageContext.getStorageManager().getStorage(clazz);
                if (currentStorage == null || currentStorage.isRecycle()) {
                    return;
                }

                AbstractStorage<?, ?> storageObject = AbstractStorage.parse(new ByteArrayInputStream(bytes), clazz, fileExtName);
                StorageContext.getStorageManager().updateStorage(clazz, storageObject);
                StorageContext.getStorageManager().inject();
            }
        }, null);
    }


    /**
     * 分布式热更新代码
     */
    public static void startHotSwapJava() {
        log.info("开启Java文件热更新");
        NetContext.getConfigManager().getRegistry().addListener(JAVA_HOTSWAP_ZK_PATH, new BiConsumer<String, byte[]>() {
            @Override
            public void accept(String path, byte[] bytes) {
                if (path.equals(JAVA_HOTSWAP_ZK_PATH)) {
                    return;
                }

                if (ArrayUtils.isEmpty(bytes)) {
                    log.info("zk收到path[{}]更新length[{}]", path, 0);
                    return;
                }

                log.info("zk收到path[{}]更新length[{}]", path, bytes.length);

                HotSwapUtils.hotswapClass(bytes);
            }
        }, null);
    }

}
