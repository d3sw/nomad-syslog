package main

import (
	"crypto/rand"
	"encoding/base64"
	"os"
	"strconv"
	"sync/atomic"
	"time"

	"go.uber.org/zap"
)

var (
	_seqNum = int32(0)
)

func getenvInt(name string, defval int) int {
	strval := os.Getenv(name)
	if strval == "" {
		return defval
	}
	intval, err := strconv.Atoi(strval)
	if err != nil {
		return defval
	}
	return intval
}

func getenvDuration(name string, defval time.Duration) time.Duration {
	strval := os.Getenv(name)
	if strval == "" {
		return defval
	}
	durval, err := time.ParseDuration(strval)
	if err != nil {
		return defval
	}
	return durval
}

func randomString(len int) string {
	buff := make([]byte, len)
	rand.Read(buff)
	str := base64.StdEncoding.EncodeToString(buff)
	// Base 64 can be longer than len
	return str[:len]
}

func runThread(tag, size, thread, start, end int) {
	for idx := start; idx < end; idx++ {
		data := randomString(size)
		seq := atomic.AddInt32(&_seqNum, 1)
		zap.L().Info("Data: "+data, zap.Int("tag", tag), zap.Int("thread", thread), zap.Int("idx", idx), zap.Int32("seq", seq))
	}
}

func runOnce() {
	atomic.StoreInt32(&_seqNum, 0)

	tag := int(time.Now().Unix())
	threads := getenvInt("LOG_THREADS", 10)
	count := getenvInt("LOG_COUNT", 100)
	size := getenvInt("LOG_SIZE", 1024)
	for idx := 0; idx < threads; idx++ {
		go runThread(tag, size, idx, idx*count, (idx+1)*count)
	}
}

func main() {
	// init
	logger, _ := zap.NewProduction()
	defer logger.Sync()
	zap.ReplaceGlobals(logger)
	// run
	interval := getenvDuration("LOG_INTERVAL", time.Minute*5)
	for {
		runOnce()
		time.Sleep(interval)
	}
}
