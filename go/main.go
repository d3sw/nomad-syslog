package main

import (
	"os"
	"strconv"
	"sync/atomic"
	"time"

	"github.com/google/uuid"
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

func runThread(tag, thread, start, end int) {
	for idx := start; idx < end; idx++ {
		data := uuid.New()
		seq := atomic.AddInt32(&_seqNum, 1)
		zap.L().Info("New GUID: "+data.String(), zap.Int("tag", tag), zap.Int("thread", thread), zap.Int("idx", idx), zap.Int32("seq", seq))
	}
}

func runOnce() {
	tag := int(time.Now().Unix())
	threads := getenvInt("LOG_THREADS", 10)
	count := getenvInt("LOG_COUNT", 100)
	for idx := 0; idx < threads; idx++ {
		go runThread(tag, idx, idx*count, (idx+1)*count)
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
