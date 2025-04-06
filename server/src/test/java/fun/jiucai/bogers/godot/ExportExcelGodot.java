/*
 * Copyright (C) 2020 The zfoo Authors
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and limitations under the License.
 */

package fun.jiucai.bogers.godot;

import com.zfoo.protocol.ProtocolManager;
import com.zfoo.protocol.buffer.ByteBufUtils;
import com.zfoo.protocol.generate.GenerateOperation;
import com.zfoo.protocol.serializer.CodeLanguage;
import com.zfoo.protocol.serializer.gdscript.CodeGenerateGdScript;
import com.zfoo.protocol.util.FileUtils;
import com.zfoo.protocol.util.StringUtils;
import com.zfoo.storage.config.StorageConfig;
import com.zfoo.storage.manager.StorageManager;
import com.zfoo.storage.util.ExportUtils;
import io.netty.buffer.ByteBufAllocator;
import io.netty.buffer.UnpooledHeapByteBuf;
import org.junit.Ignore;
import org.junit.Test;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.util.ArrayList;

/**
 * @author godotg
 */
@Ignore
public class ExportExcelGodot {

    public static final String scanPackage = "fun.jiucai.bogers.godot";
    public static final String excelPath = "classpath:/excel-godot";

    public static final String godotProjectPath = "C:/github/godot-bird";


    public static final StorageConfig config = new StorageConfig();
    public static final StorageManager storageManager = new StorageManager();

    static {
        config.setScanPackage(scanPackage);
        config.setResourceLocation(excelPath);
        config.setWriteable(true);
        config.setRecycle(false);

        storageManager.setStorageConfig(config);
        storageManager.initBefore();
        storageManager.initAfter();
    }

    @Test
    public void exportProtocolAndExcel() {
        // 生成配置协议
        exportProtocols();

        // 生成配置数据
        var resourceData = ExportUtils.autoWrapData(ResourceStorage.class, storageManager.storageMap());
        var buffer = new UnpooledHeapByteBuf(ByteBufAllocator.DEFAULT, 100, Integer.MAX_VALUE);
        ProtocolManager.write(buffer, resourceData);

        var generateBinaryPath = StringUtils.format("{}/godot_resource_storage.bin.txt", godotProjectPath);
        FileUtils.deleteFile(new File(generateBinaryPath));
        FileUtils.writeInputStreamToFile(new File(generateBinaryPath), new ByteArrayInputStream(ByteBufUtils.readAllBytes(buffer)));
        System.out.println(StringUtils.format("导出Excel成功，导出个数[{}]", storageManager.storageMap().size()));
    }


    @Test
    public void exportProtocols() {
        // 生成协议
        var protocols = new ArrayList<Class<?>>();
        protocols.add(ResourceStorage.class);
        protocols.addAll(storageManager.storageMap().keySet());
        var operation = new GenerateOperation();
        operation.setProtocolPath(godotProjectPath);
        operation.getGenerateLanguages().add(CodeLanguage.GdScript);
        CodeGenerateGdScript.protocolOutputRootPath = "storage";

        ProtocolManager.initProtocolAuto(protocols, operation);
        var count = 0;
        for (int i = 0; i < ProtocolManager.MAX_PROTOCOL_NUM; i++) {
            if (ProtocolManager.protocols[i] != null) {
                count++;
            }
        }
        System.out.println(StringUtils.format("导出协议成功，导出个数[{}]", count));
    }

}
